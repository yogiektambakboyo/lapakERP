<!-- ================== BEGIN core-js ================== -->
<script src="/assets/js/vendor.min.js"></script>
<script src="/assets/js/app.min.js"></script>
<script src="/js/app.js"></script>
<!-- ================== END core-js ================== -->


<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.26.0/moment.js"></script>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
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
</script>
@stack('scripts')