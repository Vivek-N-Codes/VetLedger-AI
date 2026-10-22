import 'package:flutter/material.dart';
import '../models/owner_ledger.dart';
import '../services/api_service.dart';
import '../services/app_data_sync.dart';
import '../theme/app_theme.dart';

class LedgerScreen extends StatefulWidget {
  final int? initialOwnerId;

  const LedgerScreen({super.key, this.initialOwnerId});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  List<OwnerLedgerSummary> _allOwners = [];
  List<OwnerLedgerSummary> _owners = [];
  OwnerLedgerDetail? _selectedOwnerDetail;
  bool _isLoading = true;
  bool _isLoadingDetail = false;
  String? _error;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOwners();
    _searchController.addListener(_applyFilters);
    AppDataSync.changeNotifier.addListener(_loadOwners);
  }

  @override
  void dispose() {
    AppDataSync.changeNotifier.removeListener(_loadOwners);
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _searchQuery = _searchController.text;
      if (query.isEmpty) {
        _owners = List.from(_allOwners);
      } else {
        _owners = _allOwners.where((o) {
          return o.name.toLowerCase().contains(query) ||
              o.phone.toLowerCase().contains(query) ||
              (o.villageName != null && o.villageName!.toLowerCase().contains(query));
        }).toList();
      }
    });
  }

  Future<void> _loadOwners() async {
    setState(() => _isLoading = true);
    try {
      final list = await ApiService.getOwnerLedgers();
      if (mounted) {
        setState(() {
          _allOwners = list;
          _isLoading = false;
          _error = null;
        });
        _applyFilters();

        if (widget.initialOwnerId != null && _selectedOwnerDetail == null) {
          _loadOwnerDetail(widget.initialOwnerId!);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _loadOwnerDetail(int ownerId) async {
    setState(() => _isLoadingDetail = true);
    try {
      final detail = await ApiService.getOwnerLedgerDetail(ownerId);
      if (mounted) {
        setState(() {
          _selectedOwnerDetail = detail;
          _isLoadingDetail = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingDetail = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load ledger: $e'), backgroundColor: AppTheme.alertRed),
        );
      }
    }
  }

  void _showRecordPaymentDialog() {
    if (_selectedOwnerDetail == null) return;
    final owner = _selectedOwnerDetail!;
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController(text: owner.outstandingBalance > 0 ? owner.outstandingBalance.toStringAsFixed(0) : '500');
    final refCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String method = 'CASH';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.payment_rounded, color: AppTheme.primaryTeal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Record Payment for ${owner.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Outstanding:', style: TextStyle(fontSize: 13)),
                        Text(
                          '₹${owner.outstandingBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: owner.outstandingBalance > 0 ? AppTheme.alertRed : AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Payment Amount (₹) *',
                      prefixText: '₹ ',
                      prefixIcon: Icon(Icons.currency_rupee_rounded, color: AppTheme.primaryTeal),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter payment amount';
                      final val = double.tryParse(v.trim());
                      if (val == null || val <= 0) return 'Enter a valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: method,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method *',
                      prefixIcon: Icon(Icons.account_balance_wallet_rounded, color: AppTheme.primaryTeal),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                      DropdownMenuItem(value: 'UPI', child: Text('UPI / QR Code')),
                      DropdownMenuItem(value: 'BANK_TRANSFER', child: Text('Direct Bank Transfer (NEFT/IMPS)')),
                      DropdownMenuItem(value: 'CHEQUE', child: Text('Cheque')),
                    ],
                    onChanged: (val) => setDialogState(() => method = val ?? 'CASH'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: refCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Transaction / Ref No. (Optional)',
                      hintText: 'e.g., UPI Ref 9832148192',
                      prefixIcon: Icon(Icons.tag_rounded, color: AppTheme.primaryTeal),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes / Remarks',
                      hintText: 'e.g., Paid via GooglePay at doorstep',
                      prefixIcon: Icon(Icons.notes_rounded, color: AppTheme.primaryTeal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  try {
                    final receipt = await ApiService.recordPayment({
                      'ownerId': owner.ownerId,
                      'amount': double.parse(amountCtrl.text.trim()),
                      'paymentMethod': method,
                      'referenceNumber': refCtrl.text.trim().isNotEmpty ? refCtrl.text.trim() : null,
                      'notes': notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                      'recordedBy': 'Dr. Sharma (Veterinarian)',
                    });
                    if (ctx.mounted) Navigator.pop(ctx);
                    _showReceiptDialog(receipt);
                    _loadOwners();
                    _loadOwnerDetail(owner.ownerId);
                    AppDataSync.notifyDataChanged();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.alertRed),
                    );
                  }
                }
              },
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptDialog(PaymentReceipt receipt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: AppTheme.successGreen),
            SizedBox(width: 8),
            Text('Official Payment Receipt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'VETLEDGER CLINICAL SERVICES',
                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Receipt #: ${receipt.receiptNumber}',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryTeal),
                      ),
                      Text('Date: ${receipt.paymentDate}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
                const Divider(height: 24),
                Text('Payer: ${receipt.ownerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Phone: ${receipt.ownerPhone}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                if (receipt.ownerAddress != null)
                  Text('Address: ${receipt.ownerAddress}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount Paid:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '₹${receipt.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.successGreen),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Method:', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    Text(receipt.paymentMethod, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                if (receipt.referenceNumber != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ref #:', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      Text(receipt.referenceNumber!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Previous Balance:', style: TextStyle(fontSize: 12)),
                    Text('₹${receipt.previousBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('New Balance:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(
                      '₹${receipt.newBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: receipt.newBalance > 0 ? AppTheme.alertRed : AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
                if (receipt.allocations.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text('Automatic FIFO Allocations:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
                  const SizedBox(height: 4),
                  ...receipt.allocations.map((a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Visit #${a.visitId} (${a.animalName ?? 'Animal'})', style: const TextStyle(fontSize: 11)),
                            Text('₹${a.allocatedAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close Receipt'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Ledger', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () {
              _loadOwners();
              if (_selectedOwnerDetail != null) {
                _loadOwnerDetail(_selectedOwnerDetail!.ownerId);
              }
            },
          ),
        ],
      ),
      body: _isLoadingDetail
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal))
          : _selectedOwnerDetail != null
              ? _buildOwnerStatementView(_selectedOwnerDetail!)
              : _buildOwnerDirectoryView(),
    );
  }

  Widget _buildOwnerDirectoryView() {
    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search owner by name, phone, or village...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryTeal),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              isDense: true,
            ),
            onChanged: (_) {},
          ),
        ),
        const Divider(height: 1, color: AppTheme.borderSubtle),

        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal))
              : _error != null
                  ? Center(child: Text('Error: $_error'))
                  : _owners.isEmpty
                      ? const Center(child: Text('No owner ledgers found'))
                      : RefreshIndicator(
                          onRefresh: _loadOwners,
                          color: AppTheme.primaryTeal,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _owners.length,
                            itemBuilder: (ctx, idx) {
                              final owner = _owners[idx];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => _loadOwnerDetail(owner.ownerId),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              owner.name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            Text(
                                              '₹${owner.outstandingBalance.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: owner.outstandingBalance > 0 ? AppTheme.alertRed : AppTheme.successGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${owner.phone} • ${owner.villageName ?? 'General'}',
                                              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                            ),
                                            Text(
                                              owner.outstandingBalance > 0 ? 'Due Balance' : 'Fully Settled',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: owner.outstandingBalance > 0 ? AppTheme.alertRed : AppTheme.successGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Billed: ₹${owner.totalBilled.toStringAsFixed(0)}',
                                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Paid: ₹${owner.totalPaid.toStringAsFixed(0)}',
                                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '${owner.totalAnimals} head across ${owner.totalFarms} farm(s)',
                                              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildOwnerStatementView(OwnerLedgerDetail owner) {
    return Column(
      children: [
        // Statement Header Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() => _selectedOwnerDetail = null),
                tooltip: 'Back to Owners',
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(owner.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${owner.phone} • ${owner.villageName ?? ''}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.payment_rounded, size: 16),
                label: const Text('Record Payment', style: TextStyle(fontSize: 13)),
                onPressed: _showRecordPaymentDialog,
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppTheme.borderSubtle),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Billed', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            const SizedBox(height: 4),
                            Text(
                              '₹${owner.totalBilled.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Paid', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            const SizedBox(height: 4),
                            Text(
                              '₹${owner.totalPaid.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.successGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: owner.outstandingBalance > 0 ? AppTheme.alertBg : AppTheme.successBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: owner.outstandingBalance > 0 ? AppTheme.alertRed.withValues(alpha: 0.3) : AppTheme.successGreen.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Outstanding', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            const SizedBox(height: 4),
                            Text(
                              '₹${owner.outstandingBalance.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: owner.outstandingBalance > 0 ? AppTheme.alertRed : AppTheme.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Clinical Visit Charges Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clinical Encounters & Charges (${owner.visits.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (owner.visits.isEmpty)
                  const Text('No billed clinical visits recorded.')
                else
                  ...owner.visits.map((v) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${v.animalName} (${v.farmName})',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(v.visitDate, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(v.presentingComplaint, style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 8),
                              // Fee breakdown row
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Consult: ₹${v.consultationFee.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
                                    Text('Services: ₹${v.serviceFee.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
                                    Text('Meds: ₹${v.medicineFee.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
                                    Text(
                                      'Total: ₹${v.totalCharge.toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: v.paymentStatus == 'PAID' ? AppTheme.successBg : AppTheme.warningBg,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        v.paymentStatus,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: v.paymentStatus == 'PAID' ? AppTheme.successGreen : AppTheme.warningAmber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),

                const SizedBox(height: 20),
                // Payment History Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment History (${owner.payments.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (owner.payments.isEmpty)
                  const Text('No payments recorded yet.')
                else
                  ...owner.payments.map((p) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppTheme.successBg,
                            child: Icon(Icons.check_rounded, color: AppTheme.successGreen),
                          ),
                          title: Text(
                            '₹${p.amount.toStringAsFixed(2)} via ${p.paymentMethod}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Receipt: ${p.receiptNumber} • ${p.paymentDate}'),
                          trailing: OutlinedButton(
                            child: const Text('Receipt', style: TextStyle(fontSize: 12)),
                            onPressed: () async {
                              try {
                                final receipt = await ApiService.getPaymentReceipt(p.paymentId);
                                _showReceiptDialog(receipt);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.alertRed),
                                );
                              }
                            },
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
