@extends('layouts.mainlayout')

@section('title', 'Pegawai')

@section('content')

<div class="pagetitle">
    <h1>Salon</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="">Home</a></li>
        <li class="breadcrumb-item">Pegawai</li>
      </ol>
    </nav>
</div>
<div class="card">
    <div class="card-body">
      <h5 class="card-title">Data Pegawai</h5>
      <a href="{{ route('pegawai.create') }}" class="btn btn-primary mb-3">Tambah Pegawai</a>

      <div class="table-responsive">
        <table class="table table-borderless datatable">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">Nama</th>
              <th scope="col">Status</th>
              <th scope="col">Aksi</th>
            </tr>
          </thead>
          <tbody>
            @forelse($pegawai as $data)
              <tr>
                <th scope="row">{{ $loop->iteration }}</th>
                <td>{{ $data['nama'] }}</td>
                <td>
                  @if($data['status'] == 1)
                    Aktif
                  @elseif($data['status'] == 2)
                    Tidak Aktif
                  @endif
                </td>
                <td>
                  <a href="{{ route('pegawai.update', $data['id']) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                  <form action="{{ route('pegawai.delete',$data['id']) }}" method="POST" class="d-inline">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')"><i class="bi bi-trash-fill"></i></button>
                  </form>
                </td>
              </tr>
            @empty
              <tr>
                <td colspan="5">Tidak ada data pegawai.</td>
              </tr>
            @endforelse
          </tbody>
        </table>
        <!-- End Table with stripped rows -->
      </div>
    </div>
</div>

@endsection
