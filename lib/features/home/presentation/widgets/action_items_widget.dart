// import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';

// import '/features/home/data/data.dart';
// import '/core/core.dart';

// class ActionItemsWidget extends StatelessWidget {
//   final List<ActionItem> actionItems;

//   const ActionItemsWidget({super.key, required this.actionItems});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.warning.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.warning.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(
//                 LucideIcons.clipboard,
//                 size: 16,
//                 color: AppColors.warning,
//               ),
//               const SizedBox(width: 8),
//               AutoSizeText(
//                 'Elementos de Acción (${actionItems.length})',
//                 style: AppTextStyles.labelMedium.copyWith(
//                   color: AppColors.warning,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 maxLines: 1,
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),

//           ...actionItems
//               .map(
//                 (item) => Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 6,
//                         height: 6,
//                         margin: const EdgeInsets.only(top: 6),
//                         decoration: const BoxDecoration(
//                           color: AppColors.warning,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: AutoSizeText(
//                           item.title,
//                           style: AppTextStyles.body2.copyWith(
//                             color: AppColors.textPrimary,
//                           ),
//                           maxLines: 2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               .toList(),
//         ],
//       ),
//     );
//   }
// }
