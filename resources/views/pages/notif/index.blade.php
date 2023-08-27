@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Notifikasi')
@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Notifikasi</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
            </div>
            <div class="col-md-2">
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table  table-striped" id="example">
         <thead>
          <tr>
             <th width="1%">No</th>
             <th>Pesan</th>
             <th width="10%">Tgl</th>
             <th width="3%">Aksi</th>
          </tr>
        </thead> 
        <tbody>
            @foreach ($notify as $key => $notif)
            <tr>
                <th>{{ $notif->id }}</th>
                <td style="<?= $notif->isread==0?'font-weight:bold;':'' ?>" >{{ $notif->message }}</td>
                <td>{{ $notif->created_at }}</td>
                <td>
                    <button class="btn btn-warning btn-sm" onclick="showMsgDialog(<?= $notif->id; ?>);">Lihat</button>
                </td>
            </tr>
            @endforeach
        </tbody>
        </table>
    </div>
@endsection

@push('scripts')
<script type="text/javascript">
const res = axios.get("{{ route('other.notif') }}", {
    headers: {
        // Overwrite Axios's automatically set Content-Type
        'Content-Type': 'application/json'
    }
}).then(resp => {
    data_notif = resp.data;
    if(data_notif.length>0){
        $('#qty_notif').removeClass("d-none");
        $('#qty_notif').text(data_notif.length);
        $('#header_notif').text(" NOTIFICATIONS  ("+data_notif.length+")");

        var content = "";
        for (let index = 0; index < data_notif.length; index++) {
            const element = data_notif[index];
            var label = "";
            if(element.notif_type == "STK" ){
                label = "Info Stok";
            }
            if(element.notif_type == "EMP" ){
                label = "Info Terapis";
            }
            if(element.notif_type == "PRC" ){
                label = "Info Transaksi Cabang";
            }
            
            if(index<5){
                content = content + '<a href="javascript:;" class="dropdown-item media"><div class="media-left"><i class="fa fa-envelope media-object bg-gray-500"></i><i class="fab fa-facebook-messenger text-blue media-object-icon"></i></div><div class="media-body"  onclick="showMsg('+element.id+');"><h6 class="media-heading" id="topic_notif_1">'+label+'</h6><p>'+element.message+'</p><div class="text-muted fs-10px">'+element.created_at+'</div></div></a>';
            }
           
        }

        $('#content_notif').html(content);
    }
});

$(document).ready(function () {
        $('#example').DataTable(
            {
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copyHtml5',
                        exportOptions: {
                            columns: ':not(.nex)'
                        }
                    },
                    {
                        extend: 'excelHtml5',
                        exportOptions: {
                            columns: ':not(.nex)'
                        }
                    }
                ]
            }
        );
    });

function showMsgDialog(id){
    $('#modal-notif').modal('show');
    
    for (let index = 0; index < data_notif.length; index++) {
        const element = data_notif[index];
        var label = "";
        if(element.notif_type == "STK" ){
            label = "Info Stok";
        }
        if(element.notif_type == "EMP" ){
            label = "Info Terapis";
        }
        if(element.notif_type == "PRC" ){
            label = "Info Transaksi Cabang";
        }
        if(element.id == id){
            $('#modal-notif-title').text('#'+id + ' - ' + label);
            $('#modal-notif-content').html(element.message);
        }
    }

    const json = JSON.stringify(
        {
            id : id,
        }
    );
    const res = axios.post("{{ route('other.notifread') }}", json, {
    headers: {
        // Overwrite Axios's automatically set Content-Type
        'Content-Type': 'application/json'
    }
    }).then(resp => {
        console.log(resp.data);

        const res = axios.get("{{ route('other.notif') }}", {
            headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
            }
        }).then(resp => {
            data_notif = resp.data;
            if(data_notif.length>0){
                $('#qty_notif').removeClass("d-none");
                $('#qty_notif').text(data_notif.length);
                $('#header_notif').text(" NOTIFICATIONS  ("+data_notif.length+")");

                var content = "";
                for (let index = 0; index < data_notif.length; index++) {
                    const element = data_notif[index];
                    var label = "";
                    if(element.notif_type == "STK" ){
                        label = "Info Stok";
                    }
                    if(element.notif_type == "EMP" ){
                        label = "Info Terapis";
                    }
                    if(element.notif_type == "PRC" ){
                        label = "Info Transaksi Cabang";
                    }
                    
                    if(index<5){
                        content = content + '<a href="javascript:;" class="dropdown-item media"><div class="media-left"><i class="fa fa-envelope media-object bg-gray-500"></i><i class="fab fa-facebook-messenger text-blue media-object-icon"></i></div><div class="media-body"  onclick="showMsg('+element.id+');"><h6 class="media-heading" id="topic_notif_1">'+label+'</h6><p>'+element.message+'</p><div class="text-muted fs-10px">'+element.created_at+'</div></div></a>';
                    }
                
                }

                $('#content_notif').html(content);
            }
        });

        
    });


}
</script>
@endpush
