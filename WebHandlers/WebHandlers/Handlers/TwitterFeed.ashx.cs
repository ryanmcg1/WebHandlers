using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace CMSApp.WWW_Shared
{
    /// <summary>
    /// Summary description for TwitterFeed
    /// </summary>
    public class TwitterFeed : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            // Based in part on the following example: http://www.codeproject.com/Articles/247336/Twitter-OAuth-authentication-using-Net
            // Tweaked to illustrate a GET request (instead of POST).
            // Demonstrates application authentication with an existing Application oAuth Token (via Twitter Developer Portal).

            string oAuthAccessToken = "4601167453-wKSVXBLbTB2geVritLzqFYVK09EUGwwT1VAcssG";// ConfigurationManager.AppSettings["TwitterOAuthAccessToken"].ToString();
            string oAuthAccessTokenSecret = "cYkwnhWHUZQeDq1QxuK8m3a9aIR19EUvlhWgzYomizOsE";// ConfigurationManager.AppSettings["TwitterOAuthAccessTokenSecret"].ToString();
            string oAuthConsumerKey = "6MP1xJARm2aQhm1fwKbmTrq8o";// ConfigurationManager.AppSettings["TwitterOAuthConsumerKey"].ToString();
            string oAuthConsumerSecret = "gzYT2lhEmygm3k6GtVt1X7fn20Ny7fdjwLdwsF25k2ULCxucG0";// ConfigurationManager.AppSettings["TwitterOAuthConsumerSecret"].ToString();
          
          
        
                        string oAuthVersion = "1.0";
            string oAuthSignatureMethod = "HMAC-SHA1";
            string oAuthNonce = Convert.ToBase64String(new ASCIIEncoding().GetBytes(DateTime.Now.Ticks.ToString()));
            TimeSpan timeSpan = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
            string oAuthTimeStamp = Convert.ToInt64(timeSpan.TotalSeconds).ToString();
            string resourceUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json";
            string screenName = "HollowsAsHomes";// ConfigurationManager.AppSettings["TwitterHandle"].ToString();
            string baseFormat = "oauth_consumer_key={0}&oauth_nonce={1}&oauth_signature_method={2}" +
                "&oauth_timestamp={3}&oauth_token={4}&oauth_version={5}&screen_name={6}";

            string baseString = string.Format(baseFormat,
                                        oAuthConsumerKey,
                                        oAuthNonce,
                                        oAuthSignatureMethod,
                                        oAuthTimeStamp,
                                        oAuthAccessToken,
                                        oAuthVersion,
                                        screenName
                                        );

            baseString = string.Concat("GET&", Uri.EscapeDataString(resourceUrl),
                         "&", Uri.EscapeDataString(baseString));

            string compositeKey = string.Concat(Uri.EscapeDataString(oAuthConsumerSecret),
                        "&", Uri.EscapeDataString(oAuthAccessTokenSecret));

            string oAuthSignature;
            using (HMACSHA1 hasher = new HMACSHA1(ASCIIEncoding.ASCII.GetBytes(compositeKey)))
            {
                oAuthSignature = Convert.ToBase64String(
                    hasher.ComputeHash(ASCIIEncoding.ASCII.GetBytes(baseString)));
            }

            var headerFormat = "OAuth oauth_nonce=\"{0}\", oauth_signature_method=\"{1}\", " +
                   "oauth_timestamp=\"{2}\", oauth_consumer_key=\"{3}\", " +
                   "oauth_token=\"{4}\", oauth_signature=\"{5}\", " +
                   "oauth_version=\"{6}\"";

            var authHeader = string.Format(headerFormat,
                                    Uri.EscapeDataString(oAuthNonce),
                                    Uri.EscapeDataString(oAuthSignatureMethod),
                                    Uri.EscapeDataString(oAuthTimeStamp),
                                    Uri.EscapeDataString(oAuthConsumerKey),
                                    Uri.EscapeDataString(oAuthAccessToken),
                                    Uri.EscapeDataString(oAuthSignature),
                                    Uri.EscapeDataString(oAuthVersion)
                            );

            ServicePointManager.Expect100Continue = false;

            // Append query string parameters to the URL
            resourceUrl += "?screen_name=" + screenName;

            // Create a new HTTP request, and append the Authorization header
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(resourceUrl);
            request.Headers.Add("Authorization", authHeader);
            request.Method = "GET";
            request.ContentType = "application/x-www-form-urlencoded";

            // Get the response and read the JSON response data
            WebResponse response = request.GetResponse();
            string responseData = new StreamReader(response.GetResponseStream()).ReadToEnd();

            // Render the JSON response out to the page
            context.Response.ContentType = "application/json";
            context.Response.Write(responseData);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}