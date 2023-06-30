<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PerawatanController;
use App\Http\Controllers\kategoriController;
use App\Http\Controllers\reservasiController;
use App\Http\Controllers\userController;
use App\Http\Controllers\jadwalController;
use App\Http\Controllers\MidtransController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\NotifikasiController;
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

Route::get('/payment-success', function () {
    return redirect()->away('io.supabase.flutterdemo://payment-success');
});


// Route for redirecting to Google for authentication
Route::get('/login/google', [LoginController::class, 'redirectToGoogle'])->name('login.google');

// Route for handling the callback from Google authentication
Route::get('/login/google/callback', [LoginController::class, 'handleGoogleCallback'])->name('login.google.callback');

// Route for handling the login form submission
Route::get('/login', [LoginController::class, 'login'])->name('login.view');



// Midtrans route
Route::get('/snap', [MidtransController::class, 'snap']);
Route::post('/pay', [MidtransController::class, 'midtranspayment']);
Route::post('/pay/notificationhandler', [MidtransController::class, 'notificationHandler']);

// Route::post('/insertpembayaran', [MidtransController::class, 'insertPembayaran']);
Route::get('/pembayaran/index', [MidtransController::class, 'selectPembayaran'])->name('pembayaran.index');
Route::delete('/pembayaran/delete/{id}', [MidtransController::class, 'deletePembayaran'])->name('pembayaran.delete');
Route::get('pembayaran/update/{id}', [MidtransController::class, 'updatePembayaran'])->name('pembayaran.update');
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

// Reservasi
Route::get('/reservasi/select', [reservasiController::class, 'selectReservasi'])->name('reservasi.index');
Route::post('/reservasi/insert', [reservasiController::class, 'insertReservasi'])->name('reservasi.create');
Route::patch('/reservasi/update/{id_reservasi}', [reservasiController::class, 'updateReservasi'])->name('reservasi.update');
Route::delete('/reservasi/delete/{id_reservasi}', [reservasiController::class, 'deleteReservasi'])->name('reservasi.delete');

// Pelanggan
Route::get('/pelanggan/index', [userController::class, 'selectPelanggan'])->name('pelanggan.index');
Route::get('/pelanggan/insert', [userController::class, 'insertPelanggan'])->name('pelanggan.create');
Route::get('/pelanggan/update/{id}', [userController::class, 'updatePelanggan'])->name('pelanggan.update');
Route::delete('/pelanggan/delete/{id}', [userController::class, 'deleteUser'])->name('pelanggan.delete');

Route::get('/pegawai/select', [userController::class, 'selectPegawai'])->name('pegawai.index');
Route::post('/pegawai/insert', [userController::class, 'insertPegawai'])->name('pegawai.create');
Route::get('/pegawai/update/{id}', [userController::class, 'updatePegawai'])->name('pegawai.update');
Route::delete('/pegawai/delete/{id}', [userController::class, 'deleteUser'])->name('pegawai.delete');

// Jadwal
Route::get('/jadwal/index', [jadwalController::class, 'selectJadwal'])->name('jadwal.index');
Route::get('/jadwal/insert', [jadwalController::class, 'insertJadwal'])->name('jadwal.create');
Route::delete('/jadwal/delete/{id}', [jadwalController::class, 'deleteJadwal'])->name('jadwal.delete');
Route::get('/jadwal/update/{id}', [jadwalController::class, 'updateJadwal'])->name('jadwal.update');;

// Notifikasi
// Route::get('/onesignal-webhook', [notifikasiController::class, 'sendNotification']);

Route::post('/send-notification', [NotifikasiController::class, 'sendNotification'])->name('send-notification');
