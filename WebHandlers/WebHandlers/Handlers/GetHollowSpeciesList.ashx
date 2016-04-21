<%@ WebHandler Language="C#" Class="GetHollowSpeciesList" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CMS.CustomTables;
using CMS.DataEngine;
using Newtonsoft.Json;
using CMS.Helpers;
using System.Text;

public class GetHollowSpeciesList : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";


        string term = SqlHelper.EscapeQuotes(ValidationHelper.GetString(context.Request.QueryString["term"],""));
        string species = SqlHelper.EscapeQuotes(ValidationHelper.GetString(context.Request.QueryString["species"],""));





        context.Response.Write(GetListOfAnimals(term,species));
    }

    private string GetListOfAnimals(string term,string species)
    {
        List<string> List = new List<string>();
        string sql = "";
        if(species != "")
        {
            sql = " and AnimalSpecies = '"+ species + "'";
        }
        ObjectQuery<CustomTableItem> q = CustomTableItemProvider.GetItems("RBGH.AnimalSpecies","AnimalName like '%"+term+"%'" + sql,null,0,null);

        //foreach(CustomTableItem c in q)
        //{
        //    List.Add(c.GetStringValue("AnimalName", ""));
        //}
        //return List;


        StringBuilder sb = new StringBuilder();
        sb.Append("{ \"suggestions\":[");

        int i = 1;
        foreach(CustomTableItem a in q)
        {
            if(i<q.Count)
            {
                sb.Append("\"" +a.GetStringValue("AnimalName","") + "\",");
            }
            else
            {
                sb.Append("\"" + a.GetStringValue("AnimalName","") + "\"");
            }
            i++;
        }

        sb.Append("]}");
        return sb.ToString();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}