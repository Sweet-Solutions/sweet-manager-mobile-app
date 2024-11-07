
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Commerce/models/comparative_incomes.dart';
import 'package:sweetmanager/Commerce/services/dashboard_service.dart';

import 'package:intl/intl.dart';

class BarChartTest extends StatefulWidget {
  const BarChartTest({super.key, required this.role});

  final String role;

  final Color leftBarColor = const Color.fromARGB(255, 235, 170, 95);
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.grey;

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartTest> {

  // Basic 
  final double width = 7;

  late String role;

  /* final List<Map<String, dynamic>> chartData = [
    {"week_number": 1, "total_income": 5000, "total_expense": 3000, "total_profit": 2000},
    {"week_number": 2, "total_income": 4500, "total_expense": 3500, "total_profit": 1000},
    {"week_number": 3, "total_income": 5200, "total_expense": 2800, "total_profit": 2400},
    {"week_number": 4, "total_income": 6000, "total_expense": 4000, "total_profit": 2000},
  ]; */

  // Services

  final storage = const FlutterSecureStorage();

  final _dashboardService = DashboardService();

  // Variables for Values Requested on API

  String subscriptionPlan = "";

  int roomCount = 0;

  int adminCount = 0;

  int workerCount = 0;  

  late List<ComparativeIncomes> chartData;

  List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    role = widget.role;

    fetchChartData();

    loadData();
  }

  Future<void> fetchChartData() async
  {
    String? requestHotelId = await _getLocality();

    int hotelId = requestHotelId != null? int.parse(requestHotelId) : 0; 

    chartData = await _dashboardService.fetchComparativeIncomesData(hotelId);

    print(chartData);

    /* int date = int.parse(DateFormat('w').format(DateTime.now()));

    print(date); */

    setState(() {
      showingBarGroups = chartData.map((data){
        return makeGroupData(
          data.weekNumber - 44,
          data.totalIncome.toDouble() / 50,
          data.totalExpense / 50
        );
      }).toList();
    });
  }

  Future<String?> _getLocality() async
  {
    // Retrieve token from local storage

    String? token = await storage.read(key: 'token');

    Map<String,dynamic> decodedToken = JwtDecoder.decode(token!);

    // Get Role in Claims token

    return decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality']?.toString();
  }


  Future<void> loadData() async 
  {
    String? requestHotelId = await _getLocality();

    int hotelId = requestHotelId != null? int.parse(requestHotelId) : 0;   

    subscriptionPlan = 'PREMIUM';

    roomCount = await _dashboardService.fetchRoomsCount(hotelId);

    workerCount = await _dashboardService.fetchWorkersCount(hotelId);

    adminCount = await  _dashboardService.fetchAdminsCount(hotelId);

  }

  @override
  Widget build(BuildContext context) {
    if(role == 'ROLE_OWNER')
    {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('WELCOME, OWNER!'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription Plan',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscriptionPlan,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatCard('Rooms', roomCount.toString() , Colors.blue),
                  buildStatCard('Admins', adminCount.toString() , Colors.black87),
                  buildStatCard('Workers', workerCount.toString() , Colors.deepPurple),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  color: Colors.grey[200],
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(width: 38),
                            const Text(
                              'Comparison: Incomes vs Expenses (Weekly)',
                              style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 38),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              maxY: 7, // 7 represents 7K as the max Y value for clarity
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (BarChartGroupData data){
                                    return Colors.blueGrey;
                                  },
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final data = chartData[groupIndex];
                                    final isIncome = rodIndex == 0;
                                    final amount = isIncome ? data.totalIncome : data.totalExpense;
                                    return BarTooltipItem(
                                      '${isIncome ? 'Income' : 'Expense'}: \$${amount}',
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    );
                                  },
                                ),
                                touchCallback: (FlTouchEvent event, response) {
                                  if (response == null || response.spot == null) {
                                    setState(() {
                                      touchedGroupIndex = -1;
                                    });
                                    return;
                                  }

                                  setState(() {
                                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitles,
                                    reservedSize: 42,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 1,
                                    getTitlesWidget: leftTitles,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: showingBarGroups,
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else if(role == 'ROLE_ADMIN')
    {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('WELCOME, ADMIN!'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription Plan',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscriptionPlan,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatCard('Rooms', roomCount.toString() , Colors.blue),
                  buildStatCard('Admins', adminCount.toString() , Colors.black87),
                  buildStatCard('Workers', workerCount.toString() , Colors.deepPurple),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  color: Colors.grey[200],
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(width: 38),
                            const Text(
                              'Comparison: Incomes vs Expenses (Weekly)',
                              style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 38),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              maxY: 7, // 7 represents 7K as the max Y value for clarity
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (BarChartGroupData data){
                                    return Colors.blueGrey;
                                  },
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final data = chartData[groupIndex];
                                    final isIncome = rodIndex == 0;
                                    final amount = isIncome ? data.totalIncome : data.totalExpense;
                                    return BarTooltipItem(
                                      '${isIncome ? 'Income' : 'Expense'}: \$${amount}',
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    );
                                  },
                                ),
                                touchCallback: (FlTouchEvent event, response) {
                                  if (response == null || response.spot == null) {
                                    setState(() {
                                      touchedGroupIndex = -1;
                                    });
                                    return;
                                  }

                                  setState(() {
                                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitles,
                                    reservedSize: 42,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 1,
                                    getTitlesWidget: leftTitles,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: showingBarGroups,
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else
    {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('WELCOME, WORKER!'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription Plan',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscriptionPlan,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatCard('Rooms', roomCount.toString() , Colors.blue),
                  buildStatCard('Admins', adminCount.toString() , Colors.black87),
                  buildStatCard('Workers', workerCount.toString() , Colors.deepPurple),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  color: Colors.grey[200],
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(width: 38),
                            const Text(
                              'Comparison: Incomes vs Expenses (Weekly)',
                              style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 38),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              maxY: 7, // 7 represents 7K as the max Y value for clarity
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (BarChartGroupData data){
                                    return Colors.blueGrey;
                                  },
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final data = chartData[groupIndex];
                                    final isIncome = rodIndex == 0;
                                    final amount = isIncome ? data.totalIncome : data.totalExpense;
                                    return BarTooltipItem(
                                      '${isIncome ? 'Income' : 'Expense'}: \$${amount}',
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    );
                                  },
                                ),
                                touchCallback: (FlTouchEvent event, response) {
                                  if (response == null || response.spot == null) {
                                    setState(() {
                                      touchedGroupIndex = -1;
                                    });
                                    return;
                                  }

                                  setState(() {
                                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: bottomTitles,
                                    reservedSize: 42,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 1,
                                    getTitlesWidget: leftTitles,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: showingBarGroups,
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0K';
    } else if (value == 3.5) {
      text = '3.5K';
    } else if (value == 7) {
      text = '7K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = ['W1', 'W2', 'W3', 'W4'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, // margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
