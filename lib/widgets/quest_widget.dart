import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:network_test/core/network/api.dart';
import 'package:network_test/features/account_management/account_model.dart';

class QuestDialog extends StatefulWidget {
  final MyIDAccount myIDAccount;
  final Map<String, dynamic> daily;
  final Map<String, dynamic> grand;
  final List<dynamic> miniQuests;

  const QuestDialog({
    super.key,
    required this.myIDAccount,
    required this.daily,
    required this.grand,
    required this.miniQuests,
  });

  @override
  State<QuestDialog> createState() => _QuestDialogState();
}

class _QuestDialogState extends State<QuestDialog> {
  late List<Map<String, dynamic>> _updatedMiniQuests;

  @override
  void initState() {
    super.initState();
    _updatedMiniQuests = widget.miniQuests.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quests Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildQuestTile(context, widget.daily),
              const Divider(),
              _buildQuestTile(context, widget.grand),
              const Divider(),
              ..._updatedMiniQuests.asMap().entries.map((entry) {
                final index = entry.key;
                final quest = entry.value;
                return _buildQuestTile(context, quest, index);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestTile(
    BuildContext context,
    Map<String, dynamic> quest, [
    int? index,
  ]) {
    final int value = quest['value'] ?? 0;
    final int total = quest['totalAction'] ?? 0;
    final int done = quest['numCompleteAction'] ?? 0;
    final bool canClaim = total > 0 && total == done;
    final bool isComplete = quest['isComplete'] == true;
    final String title = quest['title'] ?? 'Quest';
    final String? buttonText = isComplete
        ? 'Claimed'
        : (canClaim ? 'Claim' : null);
    final String? urlCallback = quest['urlCallBack'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: total > 0 ? done / total : 0,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$done / $total', style: const TextStyle(fontSize: 12)),
              Text('🎁 $value points', style: const TextStyle(fontSize: 12)),
            ],
          ),
          if (buttonText != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isComplete || urlCallback == null
                    ? null
                    : () async {
                        final result = await claimMiniQuest(
                          widget.myIDAccount.phoneNumber,
                          widget.myIDAccount.accessToken!,
                          urlCallback,
                        );

                        if (result["success"] == true &&
                            result["code"] == "SUCCESS") {
                          Fluttertoast.showToast(
                            msg: result["message"],
                            toastLength: Toast.LENGTH_SHORT,
                            textColor: Colors.green,
                          );
                          setState(() {
                            _updatedMiniQuests[index!]['isComplete'] = true;
                          });
                          return;
                        }

                        Fluttertoast.showToast(
                          msg: result["message"],
                          toastLength: Toast.LENGTH_SHORT,
                          textColor: Colors.red,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isComplete ? Colors.grey : Colors.green,
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<String> claimQuestReward(String url, String msisdn) async {
    final fullUrl = url.replaceAll('{msisdn}', msisdn);
    try {
      final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        return 'Claim successful';
      } else {
        return 'Claim failed: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error claiming reward';
    }
  }
}

// USAGE EXAMPLE (within build):
// showDialog(
//   context: context,
//   builder: (_) => QuestDialog(
//     daily: mainScreenResponse['daily'],
//     grand: mainScreenResponse['grand'],
//     miniQuests: mainScreenResponse['miniQuest'],
//   ),
// );
