import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app/l10n/generated/app_localizations.dart';

import '../../../../models/notice.dart';
import '../../../../services/notice_service.dart';

class UserNoticeListWidget extends StatefulWidget {
  const UserNoticeListWidget({super.key});

  @override
  State<UserNoticeListWidget> createState() => UserNoticeListWidgetState();
}

class UserNoticeListWidgetState extends State<UserNoticeListWidget> {
  final NoticeService _noticeService = NoticeService();
  late Future<List<Notice>> _noticesFuture;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  /// Permet d'être appelée depuis la page parent après la création d'une notif
  void refresh() {
    setState(() {
      _noticesFuture = _noticeService.getUserNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          l10n.myFeedbackTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Notice>>(
          future: _noticesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState(l10n);
            }

            final notices = snapshot.data!;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildNoticeCard(notices[index], l10n);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoticeCard(Notice notice, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          title: Text(
            notice.title.trim(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildStatusBadge(notice.status, l10n),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notice.tagName,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                ),
                if (notice.objectProfileTitle != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notice.objectProfileTitle!,
                      style: TextStyle(fontSize: 11, color: Colors.blue.shade800, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
            onPressed: () => _confirmDelete(notice.idNotice, l10n),
          ),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                notice.content.trim(),
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, AppLocalizations l10n) {
    final bool isPending = status.toUpperCase() == 'PENDING';

    final Color bgColor = isPending ? Colors.red.shade50 : Colors.green.shade50;
    final Color textColor = isPending ? Colors.red.shade700 : Colors.green.shade700;
    final IconData icon = isPending ? Icons.hourglass_top_rounded : Icons.check_circle_outline_rounded;
    final String label = isPending ? l10n.statusPending : l10n.statusTakenIntoAccount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPending ? Colors.red.shade200 : Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            l10n.emptyNoticeTitle,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.emptyNoticeDesc,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          2,
              (index) => Container(
            height: 75,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int idNotice, AppLocalizations l10n) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteNoticeTitle),
        content: Text(l10n.deleteNoticeConfirm),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _noticeService.deleteNotice(idNotice);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noticeDeletedSuccess), backgroundColor: Colors.green),
          );
          refresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noticeDeleteError), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}