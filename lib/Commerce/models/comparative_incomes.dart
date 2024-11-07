class ComparativeIncomes {
  int weekNumber;

  int totalIncome;

  double totalExpense;

  double totalProfit;

  ComparativeIncomes({required this.weekNumber, required this.totalIncome, required this.totalExpense, required this.totalProfit});


  // Método de fábrica para crear una instancia a partir de JSON
  factory ComparativeIncomes.fromJson(Map<String, dynamic> json) {
    return ComparativeIncomes(
      weekNumber: json['weekNumbers'],
      totalIncome: json['totalIncome'],
      totalExpense: json['totalExpense'],
      totalProfit: json['totalProfit'],
    );
  }

}