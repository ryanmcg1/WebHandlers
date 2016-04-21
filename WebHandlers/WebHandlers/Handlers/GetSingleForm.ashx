<%@ WebHandler Language="C#" Class="GetSingleForm" %>

using System;
using System.Web;
using System.IO;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text;
using RBGH.Services;
using CMS.Helpers;

public class GetSingleForm : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";

        int ItemID = ValidationHelper.GetInteger(context.Request.QueryString["ItemID"].ToString(),0);
        
        if(UserController.HasPermission(ItemID))
        {
            context.Response.Write(JsonConvert.SerializeObject(FormController.GetSingleForm(ItemID)));
        }
        else
        {
            context.Response.Write(JsonConvert.SerializeObject(JsonConvert.SerializeObject("No permission")));
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}