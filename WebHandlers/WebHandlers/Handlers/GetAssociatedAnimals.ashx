<%@ WebHandler Language="C#" Class="GetAssociatedAnimals" %>

using System;
using System.Web;
using System.IO;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text;
using CMS.Helpers;
using RBGH.Data;
using RBGH.Services;
using CMS.CustomTables;
using CMS.DataEngine;

public class GetAssociatedAnimals : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";

        int term = ValidationHelper.GetInteger(context.Request.QueryString["HollowFormItemID"],0);
        if(term !=0)
        {
            context.Response.Write(JsonConvert.SerializeObject(AnimalController.GetAnimals(term)));
        }
        else
        {
            context.Response.Write(JsonConvert.SerializeObject("Not found"));
        }


    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}