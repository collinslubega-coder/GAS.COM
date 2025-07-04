import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/order_model.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');

    return Consumer<UserDataService>(
      builder: (context, userDataService, child) {
        final double totalSales =
            userDataService.orders.fold(0, (sum, order) => sum + order.total);
        final int orderCount = userDataService.orders.length;

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sales and Conversions",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: defaultPadding),
                Row(
                  children: [
                    MetricCard(
                      title: "Total Sales",
                      value: currencyFormatter.format(totalSales),
                    ),
                    const SizedBox(width: defaultPadding),
                    MetricCard(
                      title: "Orders",
                      value: orderCount.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding * 2),
                Text(
                  "Sales Chart (Last 7 Days)",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: defaultPadding),
                SizedBox(
                  height: 250,
                  child: SalesChart(orders: userDataService.orders),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadious)),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.day, this.sales);
  final String day;
  final double sales;
}

class SalesChart extends StatelessWidget {
  const SalesChart({super.key, required this.orders});

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: const NumericAxis(
             majorGridLines: MajorGridLines(width: 0),
             isVisible: false
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<SalesData, String>>[
            SplineAreaSeries<SalesData, String>(
              dataSource: _getChartData(),
              xValueMapper: (SalesData sales, _) => sales.day,
              yValueMapper: (SalesData sales, _) => sales.sales,
              name: 'Sales',
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              borderColor: Theme.of(context).primaryColor,
              borderWidth: 2,
            )
          ],
        ),
      ),
    );
  }

  List<SalesData> _getChartData() {
    final Map<String, double> salesByDay = {};
    final today = DateTime.now();
    final List<SalesData> chartData = [];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dayKey = DateFormat.E().format(date); 
      salesByDay[dayKey] = 0.0;
    }

    for (final order in orders) {
      final difference = today.difference(order.date).inDays;
      if (difference >= 0 && difference < 7) {
        final dayKey = DateFormat.E().format(order.date);
        salesByDay[dayKey] = (salesByDay[dayKey] ?? 0.0) + order.total;
      }
    }

    for (int i = 6; i >= 0; i--) {
        final date = today.subtract(Duration(days: i));
        final dayKey = DateFormat.E().format(date);
        chartData.add(SalesData(dayKey, salesByDay[dayKey]!));
    }
    
    return chartData;
  }
}