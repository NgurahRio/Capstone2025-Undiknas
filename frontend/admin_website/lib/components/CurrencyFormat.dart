String formatRupiah(dynamic value) {
  int number = (value is String) ? int.parse(value) : value;

  return number.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}
