<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // عند بدء التطبيق
    }

    void Application_BeginRequest(object sender, EventArgs e)
    {

        // اقرأ اللغة من الكوكيز
        HttpCookie langCookie = Request.Cookies["lang"];
        string lang = (langCookie != null && !string.IsNullOrEmpty(langCookie.Value))
                        ? langCookie.Value
                        : "ar"; // افتراضي عربي

        // حاول تعيين culture و uiCulture
        try
        {
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
        }
        catch
        {
            // fallback لو اللغة غير صالحة
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo("ar");
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
        }

    }

    void Application_AcquireRequestState(object sender, EventArgs e)
    {
        // لو HttpContext غير متاح نخرج
        if (HttpContext.Current == null) return;

        // استثناء ملفات الموارد
        string path = HttpContext.Current.Request.Path.ToLower();
        if (path.EndsWith("webresource.axd") || path.EndsWith("scriptresource.axd")) return;

        // قراءة الكوكي
        HttpCookie langCookie = HttpContext.Current.Request.Cookies["lang"];
        string lang = (langCookie != null && !string.IsNullOrEmpty(langCookie.Value))
                        ? langCookie.Value
                        : "ar"; // افتراضي

        System.Globalization.CultureInfo ci;
        switch (lang)
        {
            case "en":
                ci = new System.Globalization.CultureInfo("en-US");
                break;
            case "ru":
                ci = new System.Globalization.CultureInfo("ru-RU");
                break;
            default:
                ci = new System.Globalization.CultureInfo("ar-EG");
                break;
        }

        System.Threading.Thread.CurrentThread.CurrentCulture = ci;
        System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
    }

    void Application_Error(object sender, EventArgs e)
    {
        // عند حدوث خطأ
    }

</script>
