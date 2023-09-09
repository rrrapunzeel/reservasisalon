@extends('layouts.mainlayout')
@extends('layouts.formlayout')

@section('title', 'Pembayaran')

@section('content')
<div class="pagetitle">
        <h1>Edit Data</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="{{ route('pembayaran.index') }}">Pembayaran</a></li>
            <li class="breadcrumb-item active">Edit</li>
          </ol>
        </nav>
      </div><!-- End Page Title -->
      <section class="section">
        <div class="row">
          <div class="card">
              <div class="card-body">
                <h5 class="card-title">Pembayaran</h5>
                @if(session('success'))
        <div class="alert alert-success mt-3">
          {{ session('success') }}
        </div>
        @endif

        <form action="{{ url('/pembayaran/updatestore', $pembayaran['id']) }}" method="PATCH">
            @csrf
            @method('PATCH')


            <div class="row mb-3">
                <label for="nama" class="col-sm-2 col-form-label">Nama</label>
                <div class="col-sm-10">
                <input type="text" class="form-control" name="nama" id="nama" value="{{ $pembayaran['nama'] }}" readonly>
            </div>
        </div>


        <div class="row mb-3">
                <label for="perawatan" class="col-sm-2 col-form-label">Total</label>
                <div class="col-sm-10">
                <input type="text" class="form-control" name="total" id="total" value="{{ $pembayaran['total'] }}"readonly>
            </div>
        </div>

        

        <div class="row mb-3">
    <label for="metode_pelunasan" class="col-sm-2 col-form-label">Metode Pelunasan</label>
    <div class="col-sm-10">
        <input type="text" class="form-control" name="metode_pelunasan" id="metode_pelunasan" value="{{ $pembayaran['metode_pelunasan'] ?? '' }}" required>
    </div>
</div>


<div class="row mb-3">
    <label for="transaction_status" class="col-sm-2 col-form-label">Status Transaksi</label>
    <div class="col-sm-10">
        <select class="form-control" name="transaction_status" id="transaction_status" required>
            <option value="Lunas" {{ $pembayaran['transaction_status'] === 'Lunas' ? 'selected' : '' }}>Lunas</option>
            <!-- Add more options as needed -->
        </select>
    </div>
</div>

        <div class="text-center">
                <button type="submit" class="btn btn-primary">Simpan</button>
                <a href="{{ url('/pembayaran/index') }}" class = "btn btn-danger">Batal</a>
            </div>
        </form>
    </div>
@endsection
