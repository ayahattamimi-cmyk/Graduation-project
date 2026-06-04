import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web2/content/view/ContentPage.dart';
import 'package:web2/dashboard/view/widgets/chart_box.dart';
import 'package:web2/dashboard/view/widgets/sidebar.dart';
import 'package:web2/dashboard/view/widgets/stat_card.dart';
import 'package:web2/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:web2/drop_locations/view/drop_locations_page.dart';
import 'package:web2/notification/view/notifications_page.dart';
import 'package:web2/report_assignment/view/report_assignment_page.dart';
import 'package:web2/reports/view/reports_page.dart';
import 'package:web2/supervisors/view/supervisor_page.dart';
import 'package:web2/map/view/map_screen.dart';
import 'package:web2/notification/viewmodel/notification_viewmodel.dart';

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
      context.read<NotificationsViewModel>().loadDashboardData();
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
        return NotificationsPage(
          onPageSelected: (AppPage page) {
            setState(() {
              currentPage = page;
            });
          },
        );
      case AppPage.assignReports:
        return const ReportAssignmentPage();
      case AppPage.map:
        return const WebMapScreen();

      case AppPage.admins:
        return const SupervisorPage();
      case AppPage.news:
        return const ContentPage();
      case AppPage.uploadSites:
        return DropLocationsPage(
          onPageSelected: (AppPage page) {
            setState(() {
              currentPage = page;
            });
          },
        );
      case AppPage.reports:
        return const ReportPage();
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
                                  Color sectionColor;
                                  if (item.type.contains("رفع")) {
                                    sectionColor = const Color(
                                      0xFF10B981,
                                    ); // Green
                                  } else if (item.type.contains("كنس")) {
                                    sectionColor = const Color(
                                      0xFF3B82F6,
                                    ); // Blue
                                  } else {
                                    sectionColor = const Color(
                                      0xFFF59E0B,
                                    ); // Orange
                                  }

                                  return PieChartSectionData(
                                    color: sectionColor,
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
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildLegendItem(
                            "رفع مخلفات",
                            const Color(0xFF10B981),
                          ),
                          _buildLegendItem(
                            "أعمال الكنس",
                            const Color(0xFF3B82F6),
                          ),
                          _buildLegendItem(
                            "بلاغات أخرى",
                            const Color(0xFFF59E0B),
                          ),
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
                    : Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 60,
                              minY: 0,
                              barTouchData: BarTouchData(enabled: true),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: 15,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index >= 0 &&
                                          index <
                                              vm
                                                  .dashboardData!
                                                  .topAreas
                                                  .length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Transform.rotate(
                                            angle: -0.5,
                                            child: Text(
                                              vm
                                                  .dashboardData!
                                                  .topAreas[index]
                                                  .name,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    reservedSize: 60,
                                  ),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 15,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.withOpacity(0.2),
                                    strokeWidth: 1,
                                    dashArray: [5, 5],
                                  );
                                },
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  left: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              barGroups:
                                  vm.dashboardData!.topAreas
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        return BarChartGroupData(
                                          x: entry.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: entry.value.count.toDouble(),
                                              color: const Color(0xFF3B82F6),
                                              width: 50,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.zero,
                                                  ),
                                            ),
                                          ],
                                        );
                                      })
                                      .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: const Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "عدد البلاغات",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
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
