<!-- ================== BEGIN core-js ================== -->
<script src="/assets/js/vendor.min.js"></script>
<script src="/assets/js/app.min.js"></script>
<script src="/js/app.js"></script>
<!-- ================== END core-js ================== -->


<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.26.0/moment.js"></script>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.html5.min.js"></script>

<script src="https://unpkg.com/currency.js@2.0.4/dist/currency.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/js/bootstrap-timepicker.min.js" integrity="sha512-2xXe2z/uA+2SyT/sTSt9Uq4jDKsT0lV4evd3eoE/oxKih8DSAsOF6LUb+ncafMJPAimWAXdu9W+yMXGrCVOzQA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdn.jsdelivr.net/npm/gridstack@7.1.0/dist/gridstack-all.js" ></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.3.0/chart.umd.js"></script>
<script src="https://cdn.datatables.net/select/1.6.2/js/dataTables.select.min.js"></script>


<script type="text/javascript">
$(function () {
    $('#datepicker').datepicker({
        format : 'yyyy-mm-dd'
    });
});
$(function () {
    $('#datepicker_2').datepicker({
        format : 'yyyy-mm-dd'
    });
});
$(function () {
    $('#timepicker1').timepicker({
        showMeridian : false
    });
});
$(function () {
    $('#timepicker2').timepicker({
        showMeridian : false
    });
});
$(".multiple-select2").select2({ placeholder: "Select a branch" });
$('#branch_id').select2({ placeholder: "Select a branch" });
if(($("#hide_val").val())!=null){
    var selectedValues = $("#hide_val").val().split(',');
    $("#branch_id").val(selectedValues).trigger('change');
}




let data_notif;
const resheader = axios.get("{{ route('other.notif') }}", {
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

        /**Swal.fire(
            {
                position: 'top-end',
                icon: 'warning',
                text: 'Ada '+data_notif.length+' notifikasi yang perlu anda lihat, silahkan klik ikon lonceng pada bagian kanan atas untuk melihat detailnya',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 5000
            }
        );**/
    }
});


function showMsg(id){
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
@stack('scripts')