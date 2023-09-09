<?php

use App\Http\Controllers\PegawaiController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PerawatanController;
use App\Http\Controllers\kategoriController;
use App\Http\Controllers\reservasiController;
use App\Http\Controllers\userController;
use App\Http\Controllers\jadwalController;
use App\Http\Controllers\MidtransController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\NotifikasiController;
use App\Http\Controllers\RegisterController;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/register', [RegisterController::class, 'register'])->name('register');
Route::get('/register/store', [RegisterController::class, 'storeRegister'])->name('register.store');

Route::get('/payment-success', function () {
    return redirect()->away('io.supabase.flutterdemo://payment-success');
});


// Route for redirecting to Google for authentication
Route::get('/login/google', [AuthController::class, 'redirectToGoogle'])->name('login.google');

// Route for handling the callback from Google authentication
Route::get('/login/google/callback', [AuthController::class, 'handleGoogleCallback'])->name('login.google.callback');

// Route for handling the login form submission
Route::get('/login', [AuthController::class, 'login'])->name('login.view');

Route::post('/store-login', [AuthController::class, 'storeLogin'])->name('login.store');

Route::post ('/register',[AuthController::class, 'register'])->name('register.store');
Route::get ('/form-register',[AuthController::class, 'showRegistrationForm'])->name('register.view');

// Route::get ('/form-signup',[RegisterController::class, 'register'])->name('form.showRegister');
// Route::get ('/store-signup',[RegisterController::class, 'storeRegister'])->name('form.showRegister');

Route::get('/profile', [AuthController::class,'getProfile'])->name('profile');


// Midtrans route
Route::get('/snap', [MidtransController::class, 'snap']);
Route::post('/pay', [MidtransController::class, 'midtranspayment']);
Route::post('/pay/notificationhandler', [MidtransController::class, 'notificationHandler']);
Route::post('/google-calendar', [MidtransController::class, 'addGoogleCalendar']);
Route::post('/transaction-status', [MidtransController::class, 'sendTransactionStatusToFlutter']);
Route::post('/send-email', [MidtransController::class, 'sendEmail']);
Route::get('/google-calendar-callback', [MidtransController::class, 'googleCalendarCallback']);
// routes/api.php

Route::post('/link-google-provider', [AuthController::class, 'linkGoogleProvider']);


// Route::post('/insertpembayaran', [MidtransController::class, 'insertPembayaran']);
Route::get('/pembayaran/index', [MidtransController::class, 'selectPembayaran'])->name('pembayaran.index');
Route::delete('/pembayaran/delete/{id}', [MidtransController::class, 'deletePembayaran'])->name('pembayaran.delete');
Route::get('pembayaran/update/{id}', [MidtransController::class, 'updatePembayaran'])->name('pembayaran.update');
Route::get('pembayaran/updatestore/{id}', [MidtransController::class, 'storeUpdate'])->name('pembayaran.storeUpdate');
Route::get('/pembayaran', [MidtransController::class, 'snap'])->name('midtrans.snap');
// Route::post('/pembayaran', [MidtransController::class, 'insertPembayaran'])->name('midtrans.payment');
Route::post('/pembayaran/create',  [MidtransController::class, 'insertPembayaran'])->name('pembayaran.create');


// Kategori
Route::get('/kategori/index', [kategoriController::class, 'selectKategori'])->name('kategori.index');
Route::get('/kategori/store', [kategoriController::class, 'storeKategori'])->name('kategori.store');
Route::get('/kategori/insert', [kategoriController::class, 'insertKategori'])->name('kategori.create');
Route::delete('/kategori/delete/{id_kategori}', [kategoriController::class, 'deleteKategori'])->name('kategori.delete');
Route::get('/kategori/update/{id_kategori}', [kategoriController::class, 'updateKategori'])->name('kategori.update');
Route::get('/kategori/updatestore/{id_kategori}', [kategoriController::class, 'storeUpdate'])->name('kategori.storeUpdate');

// Perawatan
Route::get('/perawatan/index', [PerawatanController::class, 'selectPerawatan'])->name('perawatan.index');
Route::get('/dashboard', [PerawatanController::class, 'selectDashboard'])->name('dashboard.view');
Route::get('/perawatan/update/{id_perawatan}', [PerawatanController::class, 'updatePerawatan'])->name('perawatan.update');
Route::get('/perawatan/updatestore/{id_perawatan}', [PerawatanController::class, 'storeUpdate'])->name('perawatan.storeUpdate');
Route::delete('/perawatan/delete/{id_perawatan}', [PerawatanController::class, 'deletePerawatan'])->name('perawatan.delete');
Route::get('/perawatan/create', [PerawatanController::class, 'insertPerawatan'])->name('perawatan.create');

Route::post('perawatan/store', [PerawatanController::class, 'storePerawatan'])->name('perawatan.store');

Route::get('/logout', [AuthController::class, 'logout'])->name('logout');
Route::post('/link-google-provider', [AuthController::class, 'linkGoogleProvider']);



// Reservasi
Route::get('/reservasi/select', [reservasiController::class, 'selectReservasi'])->name('reservasi.index');
Route::get('/reservasi/insert', [reservasiController::class, 'insertReservasi'])->name('reservasi.create');

Route::post('reservasi/store', [reservasiController::class, 'storeReservasi'])->name('reservasi.store');

Route::patch('/reservasi/update/{id_reservasi}', [reservasiController::class, 'updateReservasi'])->name('reservasi.update');
Route::delete('/reservasi/delete/{id_reservasi}', [reservasiController::class, 'deleteReservasi'])->name('reservasi.delete');

// Pelanggan
Route::get('/pelanggan/index', [userController::class, 'selectPelanggan'])->name('pelanggan.index');
Route::get('/pelanggan/update/{id}', [userController::class, 'updatePelanggan'])->name('pelanggan.update');
Route::get('/pelanggan/updatestore/{id}', [userController::class, 'storeUpdate'])->name('pelanggan.storeUpdate');
Route::delete('/pelanggan/delete/{id}', [userController::class, 'deleteUser'])->name('pelanggan.delete');

Route::get('/pegawai/select', [PegawaiController::class, 'selectPegawai'])->name('pegawai.index');
Route::get('/pegawai/insert', [PegawaiController::class, 'insertPegawai'])->name('pegawai.create');
Route::post('/pegawai/store', [PegawaiController::class, 'storePegawai'])->name('pegawai.store');
Route::get('/pegawai/update/{id}', [PegawaiController::class, 'updatePegawai'])->name('pegawai.update');
Route::patch('/pegawai/updatestore/{id}', [PegawaiController::class, 'storeUpdate'])->name('pegawai.storeUpdate');
Route::delete('/pegawai/delete/{id}', [PegawaiController::class, 'deleteUser'])->name('pegawai.delete');

// Jadwal
Route::get('/jadwal/index', [jadwalController::class, 'selectJadwal'])->name('jadwal.index');
Route::get('/jadwal/insert', [jadwalController::class, 'insertJadwal'])->name('jadwal.create');
Route::delete('/jadwal/delete/{id}', [jadwalController::class, 'deleteJadwal'])->name('jadwal.delete');
Route::get('/jadwal/update/{id}', [jadwalController::class, 'updateJadwal'])->name('jadwal.update');
Route::post('/jadwal/filter', [jadwalController::class, 'filter'])->name('jadwal.filter');


// Notifikasi
// Route::get('/onesignal-webhook', [notifikasiController::class, 'sendNotification']);

Route::post('/send-notification', [NotifikasiController::class, 'sendNotification'])->name('send-notification');
