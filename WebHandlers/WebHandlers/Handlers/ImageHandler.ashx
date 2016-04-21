<%@ WebHandler Language="C#" Class="ImageHandler" %>

using System;
using System.Web;
using System.IO;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text;
using CMS.MediaLibrary;
using CMS.SiteProvider;
using CMS.CustomTables;
using CMS.Helpers;

public class ImageHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        //string formID = ValidationHelper.GetString(context.Request["ItemID"].ToString(),"");
        string Description =   ValidationHelper.GetString(context.Request["Description"], "");
        string hollowFaunaFlora = ValidationHelper.GetString(context.Request["Type"], "Fauna");

        var directory = HttpContext.Current.Server.MapPath("~");

        string KenticoImageDir = "RoyalBotanicGarden/media/RBGHHollowImages/";
        string dir = directory+ KenticoImageDir + hollowFaunaFlora;


        string strExtension = "";
        Dictionary<string,string> fileListDict = new Dictionary<string, string>();
        string retVal = "";

        if(context.Request.Files.Count > 0)
        {
            for (int i = 0; i < context.Request.Files.Count; i++)
            {
                HttpPostedFile fileUpload = context.Request.Files[i];

                strExtension = Path.GetExtension(fileUpload.FileName).ToLower();
                var file = context.Request.Files[i];

                string name = "Hollow_" + hollowFaunaFlora + "_" + DateTime.Now.ToString("MMddyyyy_hhmmsstt");
                string FileName = name + strExtension;
                string path = Path.Combine(dir, FileName);

                context.Request.Files[i].SaveAs(path);

                //MediaLib
                MediaLibraryInfo library = MediaLibraryInfoProvider.GetMediaLibraryInfo("RBGHHollowsImages", SiteContext.CurrentSiteName);
                if(library != null)
                {
                    MediaFileInfo medLibFile = new MediaFileInfo();
                    medLibFile.FileName = name;
                    medLibFile.FileTitle = "";
                    medLibFile.FileDescription = Description;
                    medLibFile.FileSiteID = SiteContext.CurrentSiteID;
                    medLibFile.FileLibraryID = library.LibraryID;
                    medLibFile.FileExtension = strExtension;
                    medLibFile.FilePath = hollowFaunaFlora + "/" + FileName;
                    medLibFile.FileSize = context.Request.Files[i].ContentLength;
                    medLibFile.FileMimeType = "image/" + strExtension.Replace(".","");

                    //Create file
                    MediaFileInfoProvider.ImportMediaFileInfo(medLibFile,53);
                    
                    retVal +=  medLibFile.FileGUID;// medLibFile.FileGUID;
                }
            }

            fileListDict.Add("newFileName", retVal);

            context.Response.Write(JsonConvert.SerializeObject(fileListDict));
        }
        else
        {
            context.Response.Write(JsonConvert.SerializeObject("No stream input."));
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}