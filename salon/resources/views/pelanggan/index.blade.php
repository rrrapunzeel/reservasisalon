@extends('layouts.mainlayout')

@section('title', 'Pelanggan')

@section('content')

<div class="pagetitle">
    <h1>Salon</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="">Home</a></li>
        <li class="breadcrumb-item">Pelanggan</li>
      </ol>
    </nav>
  </div>
  <section class="section dashboard">
      <div class="row">
<div class="card">
    <div class="card-body">
      <h5 class="card-title">Data Pelanggan</h5>
      <a href="{{ route('pelanggan.create') }}" class="btn btn-primary mb-3">Tambah pelanggan</a>

      <div class="table-responsive">
      <table class="table table-borderless datatable">
        <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Nama</th>
            <th scope="col">Email </th>
            <th scope="col">Nomor Telepon</th>
            <th scope="col">Role</th>
            <th scope="col">Aksi</th>
          </tr>
        </thead>
        <tbody>
            @forelse($pelanggan as $user)
                <tr>
                    <th scope="row">{{ $loop->iteration }}</th>
                    <td>{{ $user->nama }}</td>
                    <td>{{ $user->email }}</td>
                    <td>{{ $user->nomor_telepon }}</td>
                    <td>{{ $user->role }}</td>

                <td>
                <a href="{{ route('pelanggan.update', $user->id) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                        <form action="{{ route('pelanggan.delete', $user->id) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')"><i class="bi bi-trash-fill"></i></button>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="5">Tidak ada data pelanggan.</td>
                </tr>
            @endforelse
        </tbody>
      </table>
      <!-- End Table with stripped rows -->

    </div>
  </div>
</section>

@endsection