class OwnerLedgerSummary {
  final int ownerId;
  final String name;
  final String phone;
  final String? email;
  final String? villageName;
  final String? address;
  final int totalFarms;
  final int totalAnimals;
  final double totalBilled;
  final double totalPaid;
  final double outstandingBalance;
  final String? lastPaymentDate;

  OwnerLedgerSummary({
    required this.ownerId,
    required this.name,
    required this.phone,
    this.email,
    this.villageName,
    this.address,
    required this.totalFarms,
    required this.totalAnimals,
    required this.totalBilled,
    required this.totalPaid,
    required this.outstandingBalance,
    this.lastPaymentDate,
  });

  factory OwnerLedgerSummary.fromJson(Map<String, dynamic> json) {
    return OwnerLedgerSummary(
      ownerId: json['ownerId'] as int? ?? 0,
      name: json['name'] as String? ?? json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? json['contactNumber'] as String? ?? '',
      email: json['email'] as String?,
      villageName: json['villageName'] as String?,
      address: json['address'] as String?,
      totalFarms: json['totalFarms'] as int? ?? json['farmCount'] as int? ?? 0,
      totalAnimals: json['totalAnimals'] as int? ?? json['animalCount'] as int? ?? 0,
      totalBilled: (json['totalBilled'] as num?)?.toDouble() ?? 0.0,
      totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
      outstandingBalance: (json['outstandingBalance'] as num?)?.toDouble() ?? 0.0,
      lastPaymentDate: json['lastPaymentDate'] as String?,
    );
  }
}

class LedgerVisitItem {
  final int visitId;
  final String visitDate;
  final String animalName;
  final String animalCode;
  final String farmName;
  final String presentingComplaint;
  final double consultationFee;
  final double serviceFee;
  final double medicineFee;
  final double otherFee;
  final double totalCharge;
  final String paymentStatus;

  LedgerVisitItem({
    required this.visitId,
    required this.visitDate,
    required this.animalName,
    required this.animalCode,
    required this.farmName,
    required this.presentingComplaint,
    required this.consultationFee,
    required this.serviceFee,
    required this.medicineFee,
    required this.otherFee,
    required this.totalCharge,
    required this.paymentStatus,
  });

  factory LedgerVisitItem.fromJson(Map<String, dynamic> json) {
    return LedgerVisitItem(
      visitId: json['visitId'] as int? ?? 0,
      visitDate: json['visitDate'] as String? ?? '',
      animalName: json['animalName'] as String? ?? '',
      animalCode: json['animalCode'] as String? ?? '',
      farmName: json['farmName'] as String? ?? '',
      presentingComplaint: json['presentingComplaint'] as String? ?? '',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      serviceFee: (json['serviceFee'] as num?)?.toDouble() ?? 0.0,
      medicineFee: (json['medicineFee'] as num?)?.toDouble() ?? 0.0,
      otherFee: (json['otherFee'] as num?)?.toDouble() ?? 0.0,
      totalCharge: (json['totalCharge'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] as String? ?? 'UNPAID',
    );
  }
}

class PaymentItem {
  final int paymentId;
  final String receiptNumber;
  final String paymentDate;
  final double amount;
  final String paymentMethod;
  final String? referenceNumber;
  final String? notes;
  final String? recordedBy;

  PaymentItem({
    required this.paymentId,
    required this.receiptNumber,
    required this.paymentDate,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.notes,
    this.recordedBy,
  });

  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    return PaymentItem(
      paymentId: (json['paymentId'] ?? json['id']) as int? ?? 0,
      receiptNumber: (json['receiptNumber'] ?? json['paymentNumber']) as String? ?? '',
      paymentDate: json['paymentDate'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? 'CASH',
      referenceNumber: json['referenceNumber'] as String?,
      notes: json['notes'] as String?,
      recordedBy: json['recordedBy'] as String?,
    );
  }
}

class OwnerLedgerDetail {
  final int ownerId;
  final String name;
  final String phone;
  final String? email;
  final String? villageName;
  final String? address;
  final double totalBilled;
  final double totalPaid;
  final double outstandingBalance;
  final List<dynamic> farms;
  final List<LedgerVisitItem> visits;
  final List<PaymentItem> payments;

  OwnerLedgerDetail({
    required this.ownerId,
    required this.name,
    required this.phone,
    this.email,
    this.villageName,
    this.address,
    required this.totalBilled,
    required this.totalPaid,
    required this.outstandingBalance,
    required this.farms,
    required this.visits,
    required this.payments,
  });

  factory OwnerLedgerDetail.fromJson(Map<String, dynamic> json) {
    List<LedgerVisitItem> visitsList = [];
    if (json['visits'] != null) {
      visitsList = (json['visits'] as List)
          .map((v) => LedgerVisitItem.fromJson(v as Map<String, dynamic>))
          .toList();
    }

    List<PaymentItem> paymentsList = [];
    if (json['payments'] != null) {
      paymentsList = (json['payments'] as List)
          .map((p) => PaymentItem.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    return OwnerLedgerDetail(
      ownerId: json['ownerId'] as int? ?? 0,
      name: json['name'] as String? ?? json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? json['contactNumber'] as String? ?? '',
      email: json['email'] as String?,
      villageName: json['villageName'] as String?,
      address: json['address'] as String?,
      totalBilled: (json['totalBilled'] as num?)?.toDouble() ?? 0.0,
      totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
      outstandingBalance: (json['outstandingBalance'] as num?)?.toDouble() ?? 0.0,
      farms: json['farms'] as List? ?? [],
      visits: visitsList,
      payments: paymentsList,
    );
  }
}

class PaymentAllocationItem {
  final int allocationId;
  final int visitId;
  final String? animalName;
  final double allocatedAmount;

  PaymentAllocationItem({
    required this.allocationId,
    required this.visitId,
    this.animalName,
    required this.allocatedAmount,
  });

  factory PaymentAllocationItem.fromJson(Map<String, dynamic> json) {
    return PaymentAllocationItem(
      allocationId: json['allocationId'] as int? ?? 0,
      visitId: json['visitId'] as int? ?? 0,
      animalName: json['animalName'] as String? ?? json['animalCode'] as String?,
      allocatedAmount: (json['allocatedAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PaymentReceipt {
  final int paymentId;
  final String receiptNumber;
  final String paymentDate;
  final double amount;
  final String paymentMethod;
  final String? referenceNumber;
  final String? notes;
  final String? recordedBy;
  final int ownerId;
  final String ownerName;
  final String ownerPhone;
  final String? ownerAddress;
  final double previousBalance;
  final double newBalance;
  final List<PaymentAllocationItem> allocations;

  PaymentReceipt({
    required this.paymentId,
    required this.receiptNumber,
    required this.paymentDate,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.notes,
    this.recordedBy,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    this.ownerAddress,
    required this.previousBalance,
    required this.newBalance,
    required this.allocations,
  });

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) {
    List<PaymentAllocationItem> allocs = [];
    final allocList = json['allocations'] ?? json['allocatedVisits'];
    if (allocList is List) {
      allocs = allocList
          .map((a) => PaymentAllocationItem.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    return PaymentReceipt(
      paymentId: (json['paymentId'] ?? json['id']) as int? ?? 0,
      receiptNumber: (json['receiptNumber'] ?? json['paymentNumber']) as String? ?? '',
      paymentDate: json['paymentDate'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? (json['amountReceived'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? 'CASH',
      referenceNumber: json['referenceNumber'] as String?,
      notes: json['notes'] as String?,
      recordedBy: json['recordedBy'] as String?,
      ownerId: json['ownerId'] as int? ?? 0,
      ownerName: json['ownerName'] as String? ?? '',
      ownerPhone: json['ownerPhone'] as String? ?? json['contactNumber'] as String? ?? '',
      ownerAddress: json['ownerAddress'] as String? ?? json['address'] as String?,
      previousBalance: (json['previousBalance'] as num?)?.toDouble() ?? 0.0,
      newBalance: (json['newBalance'] as num?)?.toDouble() ?? (json['remainingBalance'] as num?)?.toDouble() ?? 0.0,
      allocations: allocs,
    );
  }
}
