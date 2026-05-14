               // 4. إظهار محتوى التاب
               $(tabId).addClass('active show');
           }

    function restoreImagePreview() {
        var hfBase64 = document.getElementById('<%= hfImageBase64.ClientID %>');
        var hfPhotoPath = document.getElementById('<%= hfPhotoPath.ClientID %>');
        var fuPhoto = document.getElementById('<%= fuPhoto.ClientID %>');
        var imgPreview = $('#<%= imgPreview.ClientID %>');

        if (hfBase64 && hfBase64.value) { 
            imgPreview.attr('src', hfBase64.value).show(); 
            if (!fuPhoto.value && $('#fileUploadStatus').length === 0) {
                $('#fileNameDisplay').text('صورة معلقة (محفوظة مؤقتاً)');
                $(fuPhoto).parent().parent().append('<small id="fileUploadStatus" class="text-success" style="display:block; margin-top:5px;"><i class="fa fa-check"></i> الصورة المرفقة محفوظة وجاهزة للحفظ النهائي</small>');
            }
        } 
        else if (hfPhotoPath && hfPhotoPath.value) {
            if (imgPreview.attr('src') && imgPreview.attr('src') !== '') {
                imgPreview.show();
                $('#fileNameDisplay').text('صورة مسجلة حالياً');
            }
        }
        else {
            $('#fileUploadStatus').remove();
            $('#fileNameDisplay').text('لم يتم اختيار ملف');
            imgPreview.hide();
        }
    }

    function previewImage(input) {
        if (input.files && input.files[0]) {
            $('#fileNameDisplay').text(input.files[0].name);
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#<%= imgPreview.ClientID %>').attr('src', e.target.result).fadeIn();
                document.getElementById('<%= hfImageBase64.ClientID %>').value = e.target.result;
                $('#fileUploadStatus').remove();
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    $(document).ready(function () {
        activeTab();
        restoreImagePreview();
    });

    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
        activeTab();
        restoreImagePreview();
    });
</script>
<script type="text/javascript">
    function WebForm_OnSubmit() {
        if (typeof (Page_Validators) !== "undefined") {
            for (var i = 0; i < Page_Validators.length; i++) {
                var val = Page_Validators[i];
                if (!val.isvalid) {
                    var tabPane = $(val).closest('.tab-pane');
                    if (tabPane.length > 0) {
                        var tabId = "#" + tabPane.attr('id');
                        document.getElementById('<%= hfSelectedTab.ClientID %>').value = tabId;
                        applyTabState(tabId);
                        break; 
                    }
                }
            }
        }
        return Page_IsValid;
    }
</script>
