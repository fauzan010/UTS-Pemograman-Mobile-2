# UTS-Pemograman-Mobile-2
Jawaban Bagian A - Teori
1. Bagaimana state management dengan Cubit membantu pengelolaan transaksi dengan logika diskon dinamis (10 Poin)

  Cubit adalah bagian dari Flutter Bloc yang digunakan untuk state management, yaitu mengelola perubahan data dan memberitahu UI ketika data berubah.
  Dalam konteks aplikasi kasir dengan diskon dinamis:
  - Cubit menyimpan state transaksi, misal daftar menu yang dipesan beserta jumlahnya.
  - Saat pengguna menambahkan/menghapus item, Cubit mengupdate state sehingga total harga otomatis dihitung ulang.
  - Untuk diskon dinamis, misal diskon per item atau diskon total:
    - Cubit bisa menyimpan logika diskon, menghitung harga final secara otomatis saat item ditambah/diubah.
    - UI (widget) mendengarkan perubahan state, sehingga harga subtotal dan total diskon langsung tampil tanpa reload manual.

2. Apa perbedaan antara diskon per item dan diskon total transaksi? Berikan contoh
penerapannya dalam aplikasi kasir.

  Diskon peritem yaitu memberikan diskon pada masing masing harga dari menu dan setiap menu dapat berbeda total diskon nya. Sedangkan diskon total transaksi yaitu jumlah harga semua pesanan jika sudah melebihi Rp.100000 maka diskon baru bisa bekerja misalnya diskon 10% dari total harga pesanan. Misalnya diskon Rp.100000 jadi Rp.90000

3. Jelaskan manfaat penggunaan widget Stack pada tampilan kategori menu di aplikasi Flutter.

  Stack adalah widget Flutter yang memungkinkan menumpuk beberapa widget di atas satu sama lain.
  Manfaatnya untuk tampilan kategori menu:
  - Overlay kategori di atas banner
    - Tombol kategori bisa “melayang” di atas banner gradient sehingga lebih estetik.
  - Layout fleksibel
    - Bisa menempatkan header/banner, tombol kategori, dan list menu dalam satu layar dengan posisi bebas.
  - Mempermudah desain modern
    - Memberikan efek depth dan layering, misal shadow tombol atau animasi transisi kategori.


