import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = "تأكيد",
    this.cancelText = "إلغاء",
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height * 0.02),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // 🔹 محتوى الحوار
            Text(
              content,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // 🔹 الأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ),
                  child: Text(cancelText),
                ),

                // زر التأكيد
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ),
                  child: Text(confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
