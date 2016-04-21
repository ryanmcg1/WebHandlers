<%@ WebHandler Language="C#" Class="GetAllFormData" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using RBGH.Services;
using Newtonsoft.Json;
using CMS.DataEngine;
using CMS.Helpers;
using RBGH.Data;
using CMS.SiteProvider;


public class GetAllFormData : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        int ItemID = ValidationHelper.GetInteger(context.Request.QueryString["ItemID"], 0);   
        var obj = FormController.GetAllFormsInfo();
        var serializedObj = JsonConvert.SerializeObject(obj);
        context.Response.Write(serializedObj);
         
    }

    public bool IsReusable
{
    get
    {
        return false;
    }
}
}
