import sys

path = r"d:\Delivery\WebSite\Admin\Pages\Menuitems.aspx"
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. CSS
css_old = "/* تنسيق الصورة داخل الجريد */\n.grid-img {"
css_new = """/* تخصيص زر رفع الصورة */
.file-upload-wrapper { position: relative; display: inline-block; width: 100%; }
.file-upload-btn { position: relative; overflow: hidden; cursor: pointer; padding: 8px 20px; font-weight: bold; }
.file-upload-input { position: absolute; top: 0; right: 0; margin: 0; padding: 0; font-size: 20px; cursor: pointer; opacity: 0; height: 100%; width: 100%; }
.file-name-display { margin-right: 15px; font-size: 13px; display: inline-block; vertical-align: middle; }

/* تنسيق الصورة داخل الجريد */
.grid-img {"""
content = content.replace(css_old, css_new)

# 2. HTML
html_old = """<asp:FileUpload ID="fuPhoto" runat="server" CssClass="form-control" />
                                                <asp:HiddenField ID="hfPhotoPath" runat="server" />"""
html_new = """<div class="file-upload-wrapper">
                                                    <div class="file-upload-btn btn btn-outline btn-info">
                                                        <i class="fa fa-cloud-upload"></i> اختر صورة للصنف
                                                        <asp:FileUpload ID="fuPhoto" runat="server" CssClass="file-upload-input" onchange="previewImage(this);" />
                                                    </div>
                                                    <span id="fileNameDisplay" class="file-name-display text-muted">لم يتم اختيار ملف</span>
                                                </div>
                                                <asp:HiddenField ID="hfPhotoPath" runat="server" />
                                                <asp:HiddenField ID="hfImageBase64" runat="server" />
                                                <div class="img-preview-box" style="margin-top: 15px;">
                                                    <asp:Image ID="imgPreview" runat="server" CssClass="img-thumbnail" style="max-width: 150px; max-height: 150px; display: none; border: 2px solid #57c7d4; border-radius: 8px;" />
                                                </div>"""
content = content.replace(html_old, html_new)

# 3. JS
js_old = """    // تشغيل عند أول مرة
    $(document).ready(function () {
        activeTab();
    });

    // إعادة التشغيل بعد الـ Postback (عشان أزرار الإضافة في مشروع Fast Delivery)
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
        activeTab();
    });
           
</script>"""
js_new = """    function restoreImagePreview() {
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

    // تشغيل عند أول مرة
    $(document).ready(function () {
        activeTab();
        restoreImagePreview();
    });

    // إعادة التشغيل بعد الـ Postback (عشان أزرار الإضافة في مشروع Fast Delivery)
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
        activeTab();
        restoreImagePreview();
    });
           
</script>"""
content = content.replace(js_old, js_new)

with open(path, "w", encoding="utf-8") as f:
    f.write(content)
