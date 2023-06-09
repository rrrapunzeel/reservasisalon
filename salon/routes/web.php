<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\perawatanController;
use App\Http\Controllers\pelangganController;
use App\Http\Controllers\pegawaiController;
use App\Http\Controllers\kategoriController;
use App\Http\Controllers\pembayaranController;
use App\Http\Controllers\reservasiController;
use App\Http\Controllers\userController;
use App\Http\Controllers\jadwalController;
use App\Http\Controllers\MidtransController;

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

// Midtrans route
Route::get('/snap', [MidtransController::class, 'snap']);
Route::post('/pay', [MidtransController::class, 'midtranspayment']);
Route::post('/pay/notificationhandler', [MidtransController::class, 'notificationHandler']);
Route::post('/insertpembayaran', [MidtransController::class, 'insertPembayaran']);
Route::get('/selectpembayaran', [MidtransController::class, 'selectPembayaran']);



// Kategori 
Route::get('/kategori/select', [kategoriController::class, 'selectKategori']);
Route::post('/kategori/insert', [kategoriController::class, 'insertKategori']);
Route::patch('/kategori/update/{id_kategori}', [kategoriController::class, 'updateKategori']);

// Perawatan

Route::get('/perawatan', [perawatanController::class, 'index']);
Route::post('/perawatan/insert', [perawatanController::class, 'insertPerawatan']);
Route::get('/perawatan/select', [perawatanController::class, 'selectPerawatan']);
Route::patch('/perawatan/update/{id}', [perawatanController::class, 'updatePerawatan']);
Route::delete('/perawatan/delete/{id_perawatan}', [perawatanController::class, 'deletePerawatan']);


// Pelanggan
Route::get('/pelanggan/select', [pelangganController::class, 'selectPelanggan']);
Route::post('/pelanggan/insert', [pelangganController::class, 'insertPelanggan']);
Route::patch('/pelanggan/update/{id_pelanggan}', [pelangganController::class, 'updatePelanggan']);
Route::delete('/pelanggan/delete/{id_pelanggan}', [pelangganController::class, 'deletePelanggan']);

// Pegawai
Route::get('/pegawai/select', [pegawaiController::class, 'selectPegawai']);
Route::post('/pegawai/insert', [pegawaiController::class, 'insertPegawai']);
Route::patch('/pegawai/update/{id_pegawai}', [pegawaiController::class, 'updatePegawai']);
Route::delete('/pegawai/delete/{id_pegawai}', [pegawaiController::class, 'deletePegawai']);

// Pembayaran
// Route::get('/pembayaran/select', [pembayaranController::class, 'selectPembayaran']);
// Route::post('/pembayaran/insert', [pembayaranController::class, 'insertPembayaran']);
// Route::patch('/pembayaran/update/{id_pembayaran}', [pembayaranController::class, 'updatePembayaran']);
// Route::delete('/pembayaran/delete/{id_pembayaran}', [pembayaranController::class, 'deletePembayaran']);

// Reservasi
Route::get('/reservasi/select', [reservasiController::class, 'selectReservasi']);
Route::post('/reservasi/insert', [reservasiController::class, 'insertReservasi']);
Route::patch('/reservasi/update/{id_reservasi}', [reservasiController::class, 'updateReservasi']);
Route::delete('/reservasi/delete/{id_reservasi}', [reservasiController::class, 'deleteReservasi']);

// User
Route::get('/user/select', [userController::class, 'selectUser']);
Route::post('/user/insert', [userController::class, 'insertUser']);
Route::patch('/user/update/{id}', [userController::class, 'updateUser']);
Route::delete('/user/delete/{id}', [userController::class, 'deleteUser']);
// Jadwal

Route::get('/', function () {
    return view('welcome');
});
