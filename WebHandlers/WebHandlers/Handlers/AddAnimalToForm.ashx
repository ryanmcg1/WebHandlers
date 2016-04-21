<%@ WebHandler Language="C#" Class="AddAnimalToForm" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CMS.CustomTables;
using Newtonsoft.Json;
using System.IO;
using CMS.Helpers;
using RBGH.Data;
using RBGH.Services;


public class AddAnimalToForm : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";
        var data = context.Request;

        var sr = new StreamReader(data.InputStream);
        var stream = sr.ReadToEnd();

        if(stream != "")
        {
            HollowAnimalsItemModel json = JsonConvert.DeserializeObject<HollowAnimalsItemModel>(stream);

            context.Response.Write(JsonConvert.SerializeObject(AnimalController.AddAnimal(json)));
        }
        else
        {
            context.Response.Write(JsonConvert.SerializeObject("No stream"));
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