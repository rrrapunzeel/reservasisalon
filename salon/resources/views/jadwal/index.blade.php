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
        <h5 class="card-title">Data Jadwal</h5>
        <a href="{{ route('jadwal.create') }}" class="btn btn-primary mb-3">Tambah Jadwal</a>
        <div class="row align-items-center">
            <div class="col-md-3">
                <div class="form-group">
                    <label for="pegawai">Pegawai</label>
                    <select name="pegawai" id="pegawai" class="form-control">
                        <option value="">Semua Pegawai</option>
                        @foreach ($pegawais as $pegawai)
                            <option value="{{ $pegawai['id'] }}">{{ $pegawai['nama'] }}</option>
                        @endforeach
                    </select>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <label for="available">Available</label>
                    <select name="available" id="available" class="form-control">
                        <option value="">Semua</option>
                        <option value="Aktif">Aktif</option>
                        <option value="Tidak Aktif">Tidak Aktif</option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <div class="input-group">
                        <button type="submit" class="btn btn-primary mb-3" style="margin-top: 35px;"><i class="bi bi-search"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table with stripped rows -->
        <table class="table table-borderless datatable">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Jam</th>
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
                        <td>
                            @foreach($pegawais as $pegawai)
                                @if($pegawai['id'] == $jadwal['idPegawai'])
                                    {{ $pegawai['nama'] }}
                                @endif
                            @endforeach
                        </td>
                        <td>
                            @if ($jadwal['available'] == 'Aktif')
                                Aktif
                            @else
                                Tidak Aktif
                            @endif
                        </td>
                        <td>
                            <a href="{{ route('jadwal.update', $jadwal['id']) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                            <form action="{{ route('jadwal.delete', $jadwal['id']) }}" method="POST" class="d-inline">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')"><i class="bi bi-trash-fill"></i></button>
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
        <!-- End Table with stripped rows -->
    </div>
</div>
@endsection
