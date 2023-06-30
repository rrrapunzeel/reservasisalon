@extends('layouts.mainlayout')

@section('title', 'Jadwal')

@section('content')
<div class="pagetitle">
    <h1>Jadwal</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="{{ route ('dashboard.view')}}">Dashboard</a></li>
        <li class="breadcrumb-item">Jadwal</li>
      </ol>
    </nav>
  </div>
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Data Kategori</h5>
            <a href="{{ route('jadwal.create') }}" class="btn btn-primary mb-3">Tambah Jadwal</a>
            <!-- Table with stripped rows -->
            <table class="table table-borderless datatable">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Jam</th>
                        <th scope="col">Tanggal</th>
                        <th scope="col">Pegawai</th>
                        <th scope="col">Available</th>
                        <th scope="col">Aksi</th>
                    </tr>
                </thead>
            <tbody>
            @forelse($jadwals as $jadwal)
            <tr>
                <th scope="row">{{ $loop->iteration }}</th>
                <td>{{ $jadwal['jam_perawatan'] }}</td>
                <td>{{ $jadwal['available'] }}</td>
                <td>
                    @foreach($pegawais as $pegawai)
                        @if($pegawai['id'] == $jadwal['idPegawai'])
                            {{ $pegawai['nama'] }}
                        @endif
                    @endforeach
                </td>
                <td>{{ $jadwal['available'] }}</td>
            
                <td>
                    <a href="{{ route('jadwal.update', $jadwal['id']) }}" class="btn btn-sm btn-primary">Edit</a>
                    <form action="{{ route('jadwal.delete', $jadwal['id']) }}" method="POST" class="d-inline">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')">Hapus</button>
                    </form>
                </td>
            </tr>
            @empty
            <tr>
                <td colspan="5">Tidak ada data jadwal.</td>
            </tr>
            @endforelse
        </tbody>
            </table>
        </div>
        <!-- End Table with stripped rows -->
        
    </div>
</div>
@endsection
