<%@ WebHandler Language="C#" Class="DBController" %>

using System;
using System.Web;
using System.Collections.Generic;
using CMS.CustomTables;
using System.IO;
using CMS.Helpers;
using Newtonsoft.Json;
using System.Text;
using CMS.SiteProvider;
using RBGH.Services;
using RBGH.Data;


public class DBController : IHttpHandler
{
    HttpContext context;

    public void ProcessRequest(HttpContext context)
    {
        this.context = context;
        context.Response.ContentType = "text/json";
        var data = context.Request;

        var sr = new StreamReader(data.InputStream);
        var stream = sr.ReadToEnd();
        if(stream != "")
        {
            HollowsItemModel json = JsonConvert.DeserializeObject<HollowsItemModel>(stream);
            var saved =  FormController.Save(json);
            context.Response.Write(JsonConvert.SerializeObject(saved.ToString()));

        }
        else
        {
            context.Response.Write(JsonConvert.SerializeObject("No stream input."));
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}

