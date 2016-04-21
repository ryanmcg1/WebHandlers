<%@ WebHandler Language="C#" Class="RemoveAnimalFromForm" %>
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


public class RemoveAnimalFromForm : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";
        //var data = context.Request;

        int AnimalItemID = ValidationHelper.GetInteger(context.Request.QueryString["animalID"].ToString(),0);

        if(AnimalItemID != 0)
        {
            context.Response.Write(JsonConvert.SerializeObject(AnimalController.RemoveAnimal(AnimalItemID)));
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