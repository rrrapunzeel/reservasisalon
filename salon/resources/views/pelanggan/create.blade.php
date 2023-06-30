@extends('layouts.mainlayout')

@section('title', 'Pelanggan')
@section('content')

<div class="card">
    <div class="card-body">
      <h5 class="card-title">Tambah Data</h5>

      <form action="{{ route('pelanggan.create') }}" method="GET">
        @csrf
        @method('POST')

        <div class="row mb-3">
            <label for="nama" class="col-sm-2 col-form-label">Nama</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="nama" name="nama" required>
            </div>
        </div>
        
        <div class="row mb-3">
            <label for="email" class="col-sm-2 col-form-label">Email</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="email" name="email" required>
            </div>
        </div>

        <div class="row mb-3">
            <label for="nomor_telepon" class="col-sm-2 col-form-label">Nomor Telepon</label>
            <div class="col-sm-10">
                <input type="number" class="form-control" id="nomor_telepon" name="nomor_telepon" required>
            </div>
        </div>

        <div class="text-center">
            <button type="submit" class="btn btn-primary">Submit</button>
            <a href="{{ url('/pelanggan/select') }}" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded">Cancel</a>
        </div>
    </form>
    <!-- End Horizontal Form -->
    </div>
</div>

@endsection
