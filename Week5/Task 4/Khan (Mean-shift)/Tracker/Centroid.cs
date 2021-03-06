using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;
using System.Windows.Forms;

using ImageProcessor;
using UIGraphic;
using Statistic;

namespace Tracker
{
	/// <summary>
	/// Summary description for Centroid.
	/// </summary>
	public class Centroid : ITracker
	{	
        public Centroid()
        {
            _imgProc = new Processor(); //create image processor
        }

        public void CreateTargetModel(Bitmap bitmap, int binCountCh1, int binCountCh2, int binCountCh3, Window targetRoi, Window searchRoi)
		{
            _targetRoi = targetRoi;
            _searchRoi = searchRoi;
            
            //Get the required section
            Bitmap cropped = GetImageSection(bitmap, targetRoi);

            //create target histogram
            _hist = _imgProc.Create1DHistogram(cropped, binCountCh1 , binCountCh2, binCountCh3);
		}
                       
		public void Track(Bitmap bitmap, out Window targetRoi, out Window searchRoi, out Dictionary<string, string> information)
		{
            //get the required image section
            Bitmap cropped = GetImageSection(bitmap, _searchRoi);
            
            //create backprojection image
            _processedImage = _imgProc.CreateBackprojectionImage(bitmap, _hist, _searchRoi.RegionOfInterest);

            //Find moments of the binary image which was selected
            Bitmap bin = _processedImage.Clone(_searchRoi.RegionOfInterest, _processedImage.PixelFormat);
            _moment = new Moment(bin);

            //Find the centroid in the whole image
            int centreX = 0;
            centreX = _targetRoi.RegionOfInterest.X + (int)(_moment.FirstMomentX / _moment.ZerothMoment);
            int centreY = 0;
            centreY = _targetRoi.RegionOfInterest.Y + (int)(_moment.FirstMomentY / _moment.ZerothMoment);

            //add information
            SaveInformation(centreX, centreY);
            
            //check validity
            if (centreX > 0 && centreY > 0)
            {

                //Move the roi & search window to the new centroid
                _targetRoi.Offset(centreX - _targetRoi.CentreX, centreY - _targetRoi.CentreY);
                _searchRoi.Offset(centreX - _searchRoi.CentreX, centreY - _searchRoi.CentreY);

                _processedImage = Drawer.DrawWindow(bitmap, _targetRoi, Color.Red);
                _processedImage = Drawer.DrawWindow(bitmap, _searchRoi, Color.Yellow);
            }

            targetRoi = _targetRoi;
            searchRoi = _searchRoi;
            
            //remove unnecessary info
            _moment.Information.Clear();
            _moment.Information.Add("Centroid: ", _targetRoi.CentreX.ToString() + ", " + _targetRoi.CentreY.ToString());

            information = _moment.Information;            
		}

        public Bitmap ProcessedImage
        {
            get { return _processedImage; }
        }

        private void SaveInformation(int centreX, int centreY)
        {
            _moment.Information.Add("Centroid", "(" + centreX.ToString() + ", " + centreY.ToString() + ")");            
        }

        private Bitmap GetImageSection(Bitmap bmp, Window roi)
        {
            roi.EnsureLimits(); //make sure it is not out of the picture
            //return _imgProc.Crop(bmp, roi.RegionOfInterest);
            return bmp.Clone(roi.RegionOfInterest, bmp.PixelFormat); //select the section            
        }

        private Processor _imgProc = null;
        private Histogram _hist = null;
        private Bitmap _processedImage = null;
        private Window _targetRoi;
        private Window _searchRoi;
        private Moment _moment = null;
    }
}
