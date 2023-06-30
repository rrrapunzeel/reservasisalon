<!-- Pembayaran.blade.php -->
@extends('layouts.mainlayout')

@section('title', 'Kategori')

@section('content')
<div class="card">
    <div class="card-body">
      <h5 class="card-title">Tambah Data</h5>

      <!-- Horizontal Form -->
      <form action="{{ route('pembayaran.create') }}" method="GET">
        @csrf
        @method('POST')
        <div class="row mb-3">
          <label for="nama" class="col-sm-2 col-form-label">Nama</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" id="nama" name="nama" required>
          </div>

          <div class="row mb-3">
          <label for="email" class="col-sm-2 col-form-label">Email</label>
          <div class="col-sm-10">
            <input type="text" class="form-control" id="email" name="email" required>
          </div>

          <div class="form-group">
            <label for="perawatan">Pilih Perawatan:</label>
                <select name="perawatan[]" id="perawatan" multiple>
                    @foreach ($perawatans as $perawatan)
                        <option value="{{ $perawatan['id_perawatan'] }}">{{ $perawatan['nama_perawatan'] }}</option>
                    @endforeach
                </select>
            </div>
        
          <div class="row mb-3">
          <label for="total" class="col-sm-2 col-form-label">Total</label>
          <div class="col-sm-10">
            <input type="number" class="form-control" id="total" name="total" required>
          </div>

        </div>
        <div class="text-center">
          <button type="submit" class="btn btn-primary">Submit</button>
        </div>
      </form><!-- End Horizontal Form -->

    </div>
</div>
@endsection

