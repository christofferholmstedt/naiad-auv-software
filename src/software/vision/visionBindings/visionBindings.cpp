#include "visionBindings.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/opencv.hpp"
#include <vector>
#include<iostream>
#include<vector>
#include<string>
#include<queue>

std::vector<cv::Mat> img(IMAGE_STORE_SIZE);
std::vector<cv::Vec3f> circles;
std::vector<cv::Vec2f> lines;
std::vector<cv::Mat> contours;
cv::VideoCapture cap;
std::vector<cv::Mat> channels;

std::queue <cv::Mat> imageBuf; // Declare a queue
int imageName=31;

cv::vector<cv::Mat> BGR;
cv::Mat blueHistVals;
cv::Mat greenHistVals;
cv::Mat redHistVals;

cv::MatND hist;

/*********************************************************************************************************************
*               START CORE WRAP                                                                                        *
*********************************************************************************************************************/
//////////////////////////////////////    IMAGE BUFFER FUNC   ////////////////////////////////////////////////////////////////////////
//func that loads in images in buffer of size IMAGE_BUFFER_SIZE(uses queue func from c++, and creates a queue of IMAGE_BUFFER_SIZE
//It loads buffer and replaces the image at img.at(0)
//NB takes images from a folder at the minute, this will need to be changed when the real input method for the system
//becomes available. 

void Core_Wrap::img_buffer()
{
  char strStorage[50]; // enough to hold all numbers up to 64-bits
  int bufSize=0;
  

  std::string folderPath = "//home/bork/Data/naiad-auv-software/src/software/vision/testImages/Front/";

  std::string result;
  std::string imageType = ".jpg";
  
  if (imageBuf.size()==0)//load image, then pop image and enter do loop
  {
	sprintf(strStorage, "%d", imageName);//imageName global, set to 1, and increases as prog scrolls through images in folder
  	result = folderPath + strStorage + imageType;
  	cv::Mat F=cv::imread(result,1);//<0 unchanged, 0 greyscale, >0 rgb
  	imageBuf.push(F);
   }
   img.at(0)=imageBuf.front();
   imageBuf.pop();
	
    //load buffer
   do{
   sprintf(strStorage, "%d", imageName);
   result = folderPath + strStorage + imageType;
   cv::Mat F=cv::imread(result,1);//<0 unchanged, 0 greyscale, >0 rgb
   imageBuf.push(F);
   imageName=imageName+1;
   bufSize=imageBuf.size();
   }while (bufSize<IMAGE_BUFFER_SIZE);
   
   std::cout<<imageName;
}


///////////////////////////////////// PRINT INTERFACES.C.INT ////////////////////////////////////////////

void Core_Wrap::printNum(int num)
{
	std::cout<<"\n number entered is:\t"<<num;	
}


///////////////////////////////////// ADD IMAGE TO VECTOR img ////////////////////////////////////////////

void Core_Wrap::push_back(char * src)
{
  img.push_back(cv::imread(src));
}


///////////////////////////////////// READ IN IMAGE ////////////////////////////////////////////

void Core_Wrap::imread(char * name)
{
  cv::imread(name);
}


///////////////////////////////////// STORE IMAGE IN img AT src POSITION ////////////////////////////////////////////

void Core_Wrap::imstore(int src, char * name)
{
  img.at(src)=cv::imread(name);
}


///////////////////////////////////// WRITE IMAGE TO FILE ////////////////////////////////////////////

int Core_Wrap::imwrite(char * name, int src)
{
  if (cv::imwrite(name, img.at(src)))
    return 1;
  else
    return 0;
}


///////////////////////////////////// DISPLAY IMAGE ////////////////////////////////////////////

void Core_Wrap::imshow(char * name, int src)
{
  cv::imshow(name, img.at(src));
}


///////////////////////////////////// WAIT FOR KEY PRESS ////////////////////////////////////////////

void Core_Wrap::waitKey(int time)
{
  cv::waitKey(time);
}


///////////////////////////////////// FIND SIZE OF IMAGE AT img.at(src)  ////////////////////////////////////////////

int Core_Wrap::size(void)
{
   return img.size();
}


Core_Wrap::Core_Wrap(){}
/*********************************************************************************************************************
*               END CORE WRAP                                                                                        *
*********************************************************************************************************************/


/*********************************************************************************************************************
*               START PROCESSING WRAP                                                                                *
*********************************************************************************************************************/

////////////////////////////////////////  CONVERT FUNCTION /////////////////////////////////////////////////////

void Processing_Wrap::cvtColor(int src, int dst, int filter)
{
	cv::cvtColor(img.at(src), img.at(dst), filter);
}


//////////////////////////////////////// CANNY  /////////////////////////////////////////////////////
// NB Canny works on an input greyscale image

void Processing_Wrap::Canny(int src, int dst, int lThresh, int hThresh, int kernelSize)
{
	cv::Canny(img.at(src), img.at(dst), lThresh, hThresh, kernelSize);
}


//////////////////////////////////////HOUGH CIRCLES//////////////////////////////////////////////////////////////
// Takes in source image index, stores result in circles vector defined above

void Processing_Wrap::HoughCircles(int src,int inverseRatioOfResolution,int minDistBetweenCenters,int cannyUpThres, int centerDetectionThreshold, int minRadius,int maxRadius )
{
	int circCount;

	cv::HoughCircles( img.at(src), circles, CV_HOUGH_GRADIENT, inverseRatioOfResolution, minDistBetweenCenters, cannyUpThres, centerDetectionThreshold, minRadius, maxRadius );
	circCount=circles.size();
	std::cout<<"circles:\t"<<circCount<<std::endl;
}


///////////////////////////////DRAW CIRCLES ///////////////////////////////////////////////
// Draw the hough circles detected, Gets input from circles vector defined above, 
// NB This function will be removed, only used for testing

void Processing_Wrap::DrawHoughCircles(int src)
{
  int i;

  for( size_t i = 0; i < circles.size(); i++ )
  {
      cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
      int radius = cvRound(circles[i][2]);
      // circle center im source, center of circle, radius, color, thickness, linetype, shift
      cv::circle( img.at(src), center, 3, cv::Scalar(0,255,0), -1, 8, 0 );
      // circle outline
      cv::circle( img.at(src), center, radius, cv::Scalar(0,0,255), 3, 8, 0 );
   }
}


/////////////////////////////// IMAGE INTENSITY FUNCTION////////////////////////////////////7
// This function searches through an image at img.at(src) pixel by pixel and prints the intensity
// value for each picture
//NB "print" has to be changed to "add to a storage vector" if it is decided that this function
//is needed. At the minute it is surplus to requirements but this will more than likely change

void Processing_Wrap::LabelPoints(int src)
{
	int x,y;
	x=y=0;
	cv::Size dim = img.at(src).size();
	cv::Mat F = img.at(src).clone();
	cv::Scalar intensity;

    for(int heightIndex=0;heightIndex<dim.height;++heightIndex)
    {
		std::cout<<"change height";
		for(int widthIndex=0;widthIndex<dim.width;++widthIndex)
		{
			intensity = F .at<uchar>(cv::Point(widthIndex,heightIndex));
			std::cout<< intensity.val[0];
		}
    }
	std::cout<<"height"<<dim.height<<"width"<<dim.width;
	cv::waitKey(0);
}


////////////////////////////////////HOUGH LINES////////////////////////////////////////////

void Processing_Wrap::HoughLines(int src, int rho, float theta, int intersectionThreshold)
{
	cv::HoughLines( img.at(src), lines, rho, theta, intersectionThreshold, 0, 0 );	 
}


///////////////////////////////DRAW HOUGH LINES////////////////////////////////////////////

void Processing_Wrap::DrawHoughLines(int cdst)
{
  int i;

  for( size_t i = 0; i < lines.size(); i++ )
  {
	float rho = lines[i][0], theta = lines[i][1];
	cv::Point pt1, pt2;
	double a = cos(theta), b = sin(theta);
	double x0 = a*rho, y0 = b *rho;

	pt1.x = cvRound(x0 + 1000*(-b));
	pt1.y = cvRound(y0 + 1000*(a));
	pt2.x = cvRound(x0 + 1000*(-b));
	pt2.y = cvRound(y0 + 1000*(a));
	line( img.at(cdst), pt1, pt2, cv::Scalar(0,0,255), 10, CV_AA);
	cv::imshow("liney", img.at(cdst));      
   }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// Contours ////////////////////////////////////////////

void Processing_Wrap::Contours(int src) // TO DO : include image-ROI
{
	//cv::Mat G;
	if(img.at(src).data)
	{
		//std::cout<<"in contour \n";
		//cv::waitKey(0);
	}
	else
	{
		std::cout<<"img not found";
		cv::waitKey(0);
	}
	//cv::Mat F=img.at(src).clone();
	//cv::imshow("precontours", F);
	//cv::waitKey(0);
//	cv::Canny(F, G, 50, 450, 3);
//	std::cout<<"wait after canny";
//	cv::waitKey(0);
//	cv::imshow("super canny",G);
//	cv::waitKey(0);
	
	cv::findContours( img.at(src), contours, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);
	//cv::waitKey(0);
	//cv::imshow("in contours", img.at(src)); //TO DO : REMOVE
	//cv::waitKey(0);
}


/////////////////////////////////////// DISPLAY CONTOURS ///////////////////////////////////////////

void Processing_Wrap::showContours(int contourOut, int contourId = -1, int thickness = 1)
{
	//cv::Mat F=img.at(src).clone();
	img.at(contourOut)=img.at(0).clone();
	cv::drawContours(img.at(contourOut), contours, contourId, cv::Scalar(0,0,255), thickness, CV_AA );
	//cv::waitKey(0);	
}


////////////////////////// APPROX POLY //////////////////////////////////////////////////////

void Processing_Wrap::approxPolyDP(double epsilon, bool closed)
{
	int rectangleCount,triCount = 0;
	std::vector<cv::Point> polys;

	for (int i =0;i<contours.size();i++)
	{
		cv::approxPolyDP(contours[i], polys, arcLength(cv::Mat(contours[i]), true)*0.02,closed);
		if (polys.size()==4)
		{
			rectangleCount++;
		}
		if (polys.size()==3)
		{
			triCount++;
		}
	}
	std::cout<<"rectangles:\t"<<rectangleCount;
    std::cout<<"\ntriangles:\t"<<triCount<<std::endl;
}


/////////////////////////////////////SPLIT CHANNELS ////////////////////////////////////////////

void Processing_Wrap::splitChannels(int src)
{
	cv::split(img.at(src), channels);
	std::cout<<"\n Image split completed. \n";
}


//////////////////////////////////// BGR HISTOGRAM ////////////////////////////////////////////

void Processing_Wrap::BGRHistogram(int numSourceArray, int histDimensionality, int histSize, float range[], bool uniform, bool accumulate)
{	
	const float *histRange[]={range};
	const int channelToBeMeasured=0;

	cv::calcHist( &channels[0], numSourceArray, channelToBeMeasured, cv::Mat(), blueHistVals, histDimensionality, &histSize, histRange, uniform, accumulate );
	cv::calcHist( &channels[1], numSourceArray, channelToBeMeasured, cv::Mat(), greenHistVals, histDimensionality, &histSize, histRange, uniform, accumulate );
	cv::calcHist( &channels[2], numSourceArray, channelToBeMeasured, cv::Mat(), redHistVals, histDimensionality, &histSize, histRange, uniform, accumulate );
}


///////////////////////////////////// display BGR Histo/////////////////////////////////////////////
// used to debug bgr histo, check if it works

void Processing_Wrap::showBGRHistogram(int histSize)
{
	int histWidth = 600; int histHeight =400;
	int bin_w = cvRound( (double)histWidth/histSize);

	cv::Mat histImage( histHeight, histWidth, CV_8UC3, cv::Scalar( 0,0,0) );

	// Normalize:input,output,lower&upper limits of normal, type of normal,-1means o/p type same as i/p type, optional mask
  	normalize(blueHistVals, blueHistVals, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat() );
  	normalize(greenHistVals, greenHistVals, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat() );
  	normalize(redHistVals, redHistVals, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat() );

  	// Draw for each channel
  	for( int i = 1; i < histSize; i++ )
  	{
      	cv::line( histImage, cv::Point( bin_w*(i-1), histHeight - cvRound(blueHistVals.at<float>(i-1)) ) ,
                       cv::Point( bin_w*(i), histHeight - cvRound(blueHistVals.at<float>(i)) ),
                       cv::Scalar( 255, 0, 0), 2, 8, 0  );//blue
      	cv::line( histImage, cv::Point( bin_w*(i-1), histHeight - cvRound(greenHistVals.at<float>(i-1)) ) ,
                       cv::Point( bin_w*(i), histHeight - cvRound(greenHistVals.at<float>(i)) ),
                       cv::Scalar( 0, 255, 0), 2, 8, 0  );//green
      	cv::line( histImage, cv::Point( bin_w*(i-1), histHeight - cvRound(redHistVals.at<float>(i-1)) ) ,
                       cv::Point( bin_w*(i), histHeight - cvRound(redHistVals.at<float>(i)) ),
                       cv::Scalar( 0, 0, 255), 2, 8, 0  );//red
  	}
  	cv::imshow("Histogram", histImage );
	cv::waitKey(0);
}


//////////////////////////////////// HSI HISTOGRAM ////////////////////////////////////////////

void Processing_Wrap::HSIHistogram(int src,int numSourceArray, int channels[], int histSize[],float hrange[],float srange[], int histDimensionality,bool uniform, bool accumulate)
{
	const float *histRange[]={hrange,srange};

    cv::calcHist(&img.at(src),numSourceArray,channels, cv::Mat(),hist,histDimensionality, histSize,histRange,uniform,accumulate);
}


///////////////////////////////////// display HSI Histo/////////////////////////////////////////////
// used to debug hsi histo, check if it works

void Processing_Wrap::showHSIHistogram(int histSize[])    
{    
    int hbins=histSize[0], sbins=histSize[1]; 
    double maxVal=0;
    int scale=10;
	
	minMaxLoc(hist,0,&maxVal,0,0);
    cv::Mat histImg = cv::Mat::zeros(sbins*scale, hbins*10, CV_8UC3);

    for( int h = 0; h < hbins; h++ )
    {
        for( int s = 0; s < sbins; s++ )
        {
            float binVal = hist.at<float>(h, s);
            int intensity = cvRound(binVal*255/maxVal);
            rectangle( histImg, cv::Point(h*scale, s*scale),
                        cv::Point( (h+1)*scale - 1, (s+1)*scale - 1),
                        cv::Scalar::all(intensity),
                        CV_FILLED );
        }
	}
    cv::imshow( "H-S Histogram", histImg );
    cv::waitKey();
}


///////////////////////  SHOW BLUE CHANNEL        ///////////////////////////////////////////

void Processing_Wrap::showBlueChannel()
{
	std::cout<<channels[0];
}


///////////////////////  SHOW GREEN CHANNEL        ///////////////////////////////////////////

void Processing_Wrap::showGreenChannel()
{
	std::cout<<channels[1];
}


///////////////////////  SHOW RED CHANNEL        ///////////////////////////////////////////

void Processing_Wrap::showRedChannel()
{
	std::cout<<channels[2];
}


///////////////////////// THRESHOLD FUNCTION     ///////////////////////////////////////////////

int Processing_Wrap::thresh(int src, int ch)
{
	std::cout<<"in thres func";
	cv::waitKey(0);
	cv::Scalar lowBound = 240,upBound = 255;
	//std::Vector dst;
	cv::Mat mask,threshOut;
	int i;
	cv::inRange(channels[0], lowBound, upBound, mask);
	
	//cv::merge(channels[2], mask);
	std::cout<<"before accumulate product"<<"\n";
	cv::imshow("mask",mask);
	//cv::imshow("channels",channels);
	cv::waitKey(0);
	//std::cout<<"channel 3"<<channels[0];
	//cv::accumulateProduct(mask, channels[2], threshOut,cv::Mat());
	channels[2].copyTo(img.at(24),mask);
	cv::imshow("after accumulate",img.at(24));
	cv::waitKey(0);
	//std::cout<<"after accumulate product"<<"\n";
	cv::Size s = mask.size();
	std::cout<<s.height<<"\t"<<s.width<<"\n";
	for(i = 0; i< s.height; i++)
	{
		std::cout<<mask.col(i) <<"\n";
		cv::waitKey(0);
	}
	return 1;
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////


Processing_Wrap::Processing_Wrap(){}
/*********************************************************************************************************************
*               END PROCESSING WRAP                                                                                  *
*********************************************************************************************************************/


/*********************************************************************************************************************
*               START PREPROCESSING WRAP                                                                             *
*********************************************************************************************************************/

///////////////////////  VIDEO CAPTURE        ///////////////////////////////////////////

void Preprocessing_Wrap::VideoCaptureOpen(void)
{
  cap.open(0);
}

void Preprocessing_Wrap::namedWindow(char * name, int num)
{
  cv::namedWindow(name, num);
}

void Preprocessing_Wrap::nextFrame(int dst)
{
  cap >> img.at(dst);
}

Preprocessing_Wrap::Preprocessing_Wrap(){}

/*********************************************************************************************************************
*               END PREPROCESSING WRAP                                                                                        *
*********************************************************************************************************************/
