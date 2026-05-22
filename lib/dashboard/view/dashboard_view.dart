import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/content/view/ContentPage.dart';
import 'package:web2/dashboard/view/chart_box.dart';
import 'package:web2/dashboard/view/sidebar.dart';
import 'package:web2/dashboard/view/stat_card.dart';
import 'package:web2/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:web2/drop_locations/view/drop_locations_page.dart';
import 'package:web2/notification/view/notifications_page.dart';
import 'package:web2/report_assignment/view/report_assignment_page.dart';
import 'package:web2/reports/view/reports_page.dart';
import 'package:web2/supervisors/view/supervisor_page.dart';

class DashboardView extends StatefulWidget {

  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  AppPage currentPage = AppPage.dashboard;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DashboardViewModel>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: Row(
        children: [
          Sidebar(
            currentPage: currentPage,
            onPageSelected: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child:
                    vm.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : vm.dashboardData == null
                        ? const Center(child: Text("فشل تحميل البيانات"))
                        : _buildMainContent(vm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(DashboardViewModel vm) {
    switch (currentPage) {
      case AppPage.dashboard:
        return _dashboardLayout(vm);
      case AppPage.notifications:
        return const NotificationsPage();
      case AppPage.assignReports:
        return const ReportAssignmentPage();
      case AppPage.map:
        return const Center(child: Text('الخريطة'));
      case AppPage.admins:
        return const SupervisorPage();
      case AppPage.news:
        return const ContentPage();
      case AppPage.uploadSites:
        return const DropLocationsPage();
      case AppPage.reports:
        return const ReportPage();
      default:
        return _dashboardLayout(vm);
    }
  }

  Widget _dashboardLayout(DashboardViewModel vm) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لوحة التحكم',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'إجمالي البلاغات',
                  value: vm.totalReports,
                  subtitle: 'جميع البلاغات المسجلة',
                  icon: Icons.trending_up,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'البلاغات المحلولة',
                  value: vm.resolvedReports,
                  subtitle: 'نسبة البلاغات المنجزة',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'قيد المعالجة',
                  value: vm.processingReports,
                  subtitle: 'بلاغات تحت الإجراء',
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'المناطق النشطة',
                  value: vm.activeAreas,
                  subtitle: 'مربعات جغرافية مسجلة',
                  icon: Icons.location_on,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ChartBox(
                  title: 'تصنيف البلاغات',
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections:
                                vm.dashboardData?.classifications.map((item) {
                                  final isWaste = item.type.contains("رفع");
                                  return PieChartSectionData(
                                    color:
                                        isWaste ? Colors.green : Colors.orange,
                                    value: item.percentage,
                                    title: '${item.percentage.toInt()}%',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem("رفع مخلفات", Colors.green),
                          const SizedBox(width: 16),
                          _buildLegendItem("بلاغات أخرى", Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ChartBox(
                  title: 'التتبع الشهري',
                  child: SizedBox(
                    height: 240,
                    child:
                        vm.dashboardData!.monthlyStats.isEmpty
                            ? const Center(child: Text("لا توجد بيانات شهرية"))
                            : LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        if (index >= 0 &&
                                            index <
                                                vm
                                                    .dashboardData!
                                                    .monthlyStats
                                                    .length) {
                                          return Text(
                                            vm
                                                .dashboardData!
                                                .monthlyStats[index]
                                                .month,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          );
                                        }
                                        return const Text("");
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots:
                                        vm.dashboardData!.monthlyStats
                                            .asMap()
                                            .entries
                                            .map((e) {
                                              return FlSpot(
                                                e.key.toDouble(),
                                                e.value.count.toDouble(),
                                              );
                                            })
                                            .toList(),
                                    isCurved: true,
                                    color: Colors.blue,
                                    barWidth: 4,
                                    isStrokeCapRound: true,
                                    dotData: const FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.blue.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ChartBox(
            title: 'أكثر المناطق تفاعلاً',
            child:
                (vm.dashboardData?.topAreas.isEmpty ?? true)
                    ? const Center(child: Text("لا توجد بيانات للمناطق"))
                    : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.dashboardData!.topAreas.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final area = vm.dashboardData!.topAreas[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          title: Text(area.name),
                          trailing: Text(
                            '${area.count} بلاغ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
