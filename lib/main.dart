import 'dart:ui';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'dart:developer' as developer;

import 'package:stack_trace/stack_trace.dart';

const String appName = 'Bybit Futures Martingale Calculator';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      logWriterCallback: (value, {isError = false}) {
        if (isError || Get.isLogEnable) {
          developer.log(
            '[${DateTime.now()}] $value\n${Trace.current().terse.frames.getRange(1, 4).join('\n')}',
            name: 'GETX',
          );
        }
      },
      title: appName,
      theme: FlexThemeData.light(
        scheme: FlexScheme.deepBlue,
        subThemesData: const FlexSubThemesData(
          inputSelectionSchemeColor: SchemeColor.white,
        ),
      ),
      home: const BybitMartingaleCalculator(),
    ),
  );
}

class BybitMartingaleCalculator extends StatefulWidget {
  const BybitMartingaleCalculator({super.key});

  @override
  State<BybitMartingaleCalculator> createState() =>
      _BybitMartingaleCalculatorState();
}

class _BybitMartingaleCalculatorState extends State<BybitMartingaleCalculator> {
  final _formKey = GlobalKey<FormState>();

  final _entryPriceController = TextEditingController(text: '116368.7');
  final _priceDecreaseController = TextEditingController(text: '4.9');
  final _positionMultiplierController = TextEditingController(text: '1.1');
  final _maxAdditionsController = TextEditingController(text: '10');
  final _profitTargetController = TextEditingController(text: '1.0');
  final _leverageController = TextEditingController(text: '20');
  final _initialInvestmentController = TextEditingController(text: '800');

  String _selectedDirection = 'Long';
  List<MartingaleLevel> _levels = [];

  @override
  void dispose() {
    _entryPriceController.dispose();
    _priceDecreaseController.dispose();
    _positionMultiplierController.dispose();
    _maxAdditionsController.dispose();
    _profitTargetController.dispose();
    _leverageController.dispose();
    _initialInvestmentController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final entryPrice = double.parse(_entryPriceController.text);
    final priceDecrease = double.parse(_priceDecreaseController.text) / 100;
    final multiplier = double.parse(_positionMultiplierController.text);
    final maxAdditions = int.parse(_maxAdditionsController.text);
    final profitTarget = double.parse(_profitTargetController.text) / 100;
    final leverage = double.parse(_leverageController.text);
    final initialInvestment = double.parse(_initialInvestmentController.text);

    setState(() {
      _levels = _calculateBybitMartingaleLevels(
        entryPrice: entryPrice,
        priceDecrease: priceDecrease,
        multiplier: multiplier,
        maxAdditions: maxAdditions,
        profitTarget: profitTarget,
        leverage: leverage,
        initialInvestment: initialInvestment,
        isLong: _selectedDirection == 'Long',
      );
    });
  }

  List<MartingaleLevel> _calculateBybitMartingaleLevels({
    required double entryPrice,
    required double priceDecrease,
    required double multiplier,
    required int maxAdditions,
    required double profitTarget,
    required double leverage,
    required double initialInvestment,
    required bool isLong,
  }) {
    List<MartingaleLevel> levels = [];
    double totalPositionSize = 0;
    double totalNotionalValue = 0;
    var levelEntryPrice = entryPrice;

    // slipt initial investment into maxAdditions parts
    var x = 1.0;
    List<double> xList = [];
    for (var i = 0; i < maxAdditions; i++) {
      xList.add(x);
      x *= multiplier;
    }

    var sum = xList.fold(0.0, (prev, element) => prev + element);
    Get.log('xList: $xList');
    Get.log('sum: $sum');

    var initialPosition = initialInvestment / sum / entryPrice * leverage;
    double currentPositionSize = initialPosition;
    double averageEntryPrice = entryPrice;

    for (int i = 0; i < maxAdditions; i++) {
      if (i != 0) {
        levelEntryPrice = isLong
            ? averageEntryPrice * (1 - priceDecrease)
            : averageEntryPrice * (1 + priceDecrease);
        currentPositionSize =
            initialInvestment / sum * xList[i] / levelEntryPrice * leverage;
      }

      totalPositionSize += currentPositionSize;
      totalNotionalValue += currentPositionSize * levelEntryPrice;

      averageEntryPrice = totalNotionalValue / totalPositionSize;
      double targetProfitAmount = initialInvestment * profitTarget;

      double targetExitPrice;
      if (isLong) {
        targetExitPrice =
            averageEntryPrice + (targetProfitAmount / totalPositionSize);
      } else {
        targetExitPrice =
            averageEntryPrice - (targetProfitAmount / totalPositionSize);
      }

      levels.add(
        MartingaleLevel(
          level: i + 1,
          side: isLong ? 'Long' : 'Short',
          entryPrice: levelEntryPrice,
          exitPrice: targetExitPrice,
          positionSize: currentPositionSize,
          totalPositionSize: totalPositionSize,
          averageEntryPrice: averageEntryPrice,
          // notionalValue: notionalValue,
          // totalNotionalValue: totalNotionalValue,
          leverage: leverage,
        ),
      );

      // if (i < maxAdditions) {
      //   currentPositionSize *= multiplier;
      // }
    }

    return levels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1426),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF7931A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.currency_bitcoin,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Futures Martingale Calculator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E2329),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildParametersCard(),
              const SizedBox(height: 16),
              _buildCalculateButton(),
              if (_levels.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildResultsTable(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParametersCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2B3139)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trading Parameters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Direction',
                      style: TextStyle(color: Color(0xFF848E9C), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDirection = 'Long'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedDirection == 'Long'
                                    ? const Color(0xFF02C076)
                                    : const Color(0xFF2B3139),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _selectedDirection == 'Long'
                                      ? const Color(0xFF02C076)
                                      : const Color(0xFF373D47),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Long',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDirection = 'Short'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedDirection == 'Short'
                                    ? const Color(0xFFF6465D)
                                    : const Color(0xFF2B3139),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _selectedDirection == 'Short'
                                      ? const Color(0xFFF6465D)
                                      : const Color(0xFF373D47),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Short',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Price and Position inputs
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  'Entry Price',
                  _entryPriceController,
                  'USDT',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  'Initial Investment',
                  _initialInvestmentController,
                  'USDT',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  _selectedDirection == 'Long'
                      ? 'Price Decrease'
                      : 'Price Increase',
                  _priceDecreaseController,
                  '%',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  'Position Multiplier',
                  _positionMultiplierController,
                  'x',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  'Max Additions per Round',
                  _maxAdditionsController,
                  'times',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  'Profit Target per Round',
                  _profitTargetController,
                  '%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildInputField('Leverage', _leverageController, 'x'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String suffix,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2B3139),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF373D47)),
          ),
          child: TextFormField(
            cursorColor: Colors.white,
            controller: controller,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixText: suffix,
              suffixStyle: const TextStyle(
                color: Color(0xFF848E9C),
                fontSize: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              if (double.tryParse(value) == null) {
                return 'Invalid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _calculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7931A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ),
        child: const Text(
          'Calculate Martingale Strategy',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildResultsTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2B3139)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Martingale Levels Detail',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF2B3139)),
            dataRowColor: WidgetStateProperty.all(const Color(0xFF1E2329)),
            dividerThickness: 1,
            headingTextStyle: const TextStyle(
              color: Color(0xFF848E9C),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            dataTextStyle: const TextStyle(color: Colors.white, fontSize: 11),
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text('Level')),
              DataColumn(label: Text('Entry Price')),
              DataColumn(label: Text('Exit Price')),
              DataColumn(label: Text('Position Size')),
              DataColumn(label: Text('Total Position')),
              DataColumn(label: Text('Avg Entry')),
            ],
            rows: _levels.map((level) {
              return DataRow(
                cells: [
                  DataCell(Text(level.level.toString())),
                  DataCell(Text(level.entryPrice.toStringAsFixed(2))),
                  DataCell(Text(level.exitPrice.toStringAsFixed(2))),
                  DataCell(Text(level.positionSize.toStringAsFixed(6))),
                  DataCell(Text(level.totalPositionSize.toStringAsFixed(6))),
                  DataCell(Text(level.averageEntryPrice.toStringAsFixed(2))),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class MartingaleLevel {
  final int level;
  final String side;
  final double entryPrice;
  final double exitPrice;
  final double positionSize;
  final double totalPositionSize;
  final double averageEntryPrice;
  // final double notionalValue;
  // final double totalNotionalValue;
  final double leverage;

  MartingaleLevel({
    required this.level,
    required this.side,
    required this.entryPrice,
    required this.exitPrice,
    required this.positionSize,
    required this.totalPositionSize,
    required this.averageEntryPrice,
    // required this.notionalValue,
    // required this.totalNotionalValue,
    required this.leverage,
  });
}
