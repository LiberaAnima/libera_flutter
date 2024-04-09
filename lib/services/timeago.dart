String timeAgo(DateTime postedAt) {
  Duration difference = DateTime.now().difference(postedAt);

  if (difference.inDays > 0) {
    return '${difference.inDays}日前';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}時間前';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}文前';
  } else {
    return 'たった今';
  }
}
