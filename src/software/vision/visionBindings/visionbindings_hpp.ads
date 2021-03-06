pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;

package visionBindings_hpp is


   IMAGE_BUFFER_SIZE : constant := 10;  --  visionBindings.hpp:6
   FRAME_RATE : constant := 1.0;  --  visionBindings.hpp:7
   NUMBER_OF_TEMPLATES : constant := 4;  --  visionBindings.hpp:8
   IMAGE_STORE_SIZE : constant := 40;  --  visionBindings.hpp:9

   package Class_Core_Wrap is
      type Core_Wrap is tagged limited record
         null;
      end record;
      pragma Import (CPP, Core_Wrap);

      procedure push_back_templeteStore (this : access Core_Wrap; src : Interfaces.C.Strings.chars_ptr);  -- visionBindings.cpp:111
      pragma Import (CPP, push_back_templeteStore, "_ZN9Core_Wrap23push_back_templeteStoreEPc");

      procedure imread (this : access Core_Wrap; name : Interfaces.C.Strings.chars_ptr);  -- visionBindings.cpp:119
      pragma Import (CPP, imread, "_ZN9Core_Wrap6imreadEPc");

      procedure imwrite
        (this : access Core_Wrap;
         name : Interfaces.C.Strings.chars_ptr;
         src : int);  -- visionBindings.cpp:135
      pragma Import (CPP, imwrite, "_ZN9Core_Wrap7imwriteEPci");

      procedure imshow
        (this : access Core_Wrap;
         name : Interfaces.C.Strings.chars_ptr;
         src : int);  -- visionBindings.cpp:147
      pragma Import (CPP, imshow, "_ZN9Core_Wrap6imshowEPci");

      procedure waitKey (this : access Core_Wrap; time : int);  -- visionBindings.cpp:155
      pragma Import (CPP, waitKey, "_ZN9Core_Wrap7waitKeyEi");

      function size (this : access Core_Wrap) return int;  -- visionBindings.cpp:163
      pragma Import (CPP, size, "_ZN9Core_Wrap4sizeEv");

      procedure img_buffer (this : access Core_Wrap);  -- visionBindings.cpp:50
      pragma Import (CPP, img_buffer, "_ZN9Core_Wrap10img_bufferEv");

      procedure imstore
        (this : access Core_Wrap;
         src : int;
         name : Interfaces.C.Strings.chars_ptr);  -- visionBindings.cpp:127
      pragma Import (CPP, imstore, "_ZN9Core_Wrap7imstoreEiPc");

      procedure printNum (this : access Core_Wrap; num : int);  -- visionBindings.cpp:103
      pragma Import (CPP, printNum, "_ZN9Core_Wrap8printNumEi");

      function New_Core_Wrap return Core_Wrap;  -- visionBindings.cpp:169
      pragma CPP_Constructor (New_Core_Wrap, "_ZN9Core_WrapC1Ev");


   end;
   use Class_Core_Wrap;
   package Class_Processing_Wrap is
      type Processing_Wrap is tagged limited record
         null;
      end record;
      pragma Import (CPP, Processing_Wrap);

      procedure cvtColor
        (this : access Processing_Wrap;
         src : int;
         dst : int;
         filter : int);  -- visionBindings.cpp:181
      pragma Import (CPP, cvtColor, "_ZN15Processing_Wrap8cvtColorEiii");

      procedure Canny
        (this : access Processing_Wrap;
         src : int;
         dst : int;
         lThresh : int;
         hThresh : int;
         kernelSize : int);  -- visionBindings.cpp:190
      pragma Import (CPP, Canny, "_ZN15Processing_Wrap5CannyEiiiii");

      procedure HoughCircles
        (this : access Processing_Wrap;
         src : int;
         inverseRatioOfResolution : int;
         minDistBetweenCenters : int;
         cannyUpThres : int;
         centerDetectionThreshold : int;
         minRadius : int;
         maxRadius : int);  -- visionBindings.cpp:199
      pragma Import (CPP, HoughCircles, "_ZN15Processing_Wrap12HoughCirclesEiiiiiii");

      procedure DrawHoughCircles
        (this : access Processing_Wrap;
         src : int;
         dest : int);  -- visionBindings.cpp:210
      pragma Import (CPP, DrawHoughCircles, "_ZN15Processing_Wrap16DrawHoughCirclesEii");

      procedure FindCircleCenters (this : access Processing_Wrap);  -- visionBindings.cpp:227
      pragma Import (CPP, FindCircleCenters, "_ZN15Processing_Wrap17FindCircleCentersEv");

      procedure HoughLines
        (this : access Processing_Wrap;
         src : int;
         rho : int;
         theta : float;
         intersectionThreshold : int);  -- visionBindings.cpp:268
      pragma Import (CPP, HoughLines, "_ZN15Processing_Wrap10HoughLinesEiifi");

      procedure HoughLinesP (this : access Processing_Wrap; src : int);  -- visionBindings.cpp:317
      pragma Import (CPP, HoughLinesP, "_ZN15Processing_Wrap11HoughLinesPEi");

      procedure DrawHoughLines (this : access Processing_Wrap; cdst : int);  -- visionBindings.cpp:276
      pragma Import (CPP, DrawHoughLines, "_ZN15Processing_Wrap14DrawHoughLinesEi");

      procedure Contours (this : access Processing_Wrap; src : int);  -- visionBindings.cpp:300
      pragma Import (CPP, Contours, "_ZN15Processing_Wrap8ContoursEi");

      procedure showContours
        (this : access Processing_Wrap;
         src : int;
         contourOut : int;
         contourId : int;
         thickness : int);  -- visionBindings.cpp:308
      pragma Import (CPP, showContours, "_ZN15Processing_Wrap12showContoursEiiii");

      procedure BGRHistogram
        (this : access Processing_Wrap;
         numSourceArray : int;
         histDimensionality : int;
         histSize : int;
         c_range : access float;
         uniform : Extensions.bool;
         accumulate : Extensions.bool);  -- visionBindings.cpp:404
      pragma Import (CPP, BGRHistogram, "_ZN15Processing_Wrap12BGRHistogramEiiiPfbb");

      procedure HSIHistogram
        (this : access Processing_Wrap;
         src : int;
         numSourceArray : int;
         channels : access int;
         histSize : access int;
         hrange : access float;
         srange : access float;
         histDimensionality : int;
         uniform : Extensions.bool;
         accumulate : Extensions.bool);  -- visionBindings.cpp:450
      pragma Import (CPP, HSIHistogram, "_ZN15Processing_Wrap12HSIHistogramEiiPiS0_PfS1_ibb");

      procedure showBGRHistogram (this : access Processing_Wrap; histSize : int);  -- visionBindings.cpp:418
      pragma Import (CPP, showBGRHistogram, "_ZN15Processing_Wrap16showBGRHistogramEi");

      procedure showHSIHistogram (this : access Processing_Wrap; histSize : access int);  -- visionBindings.cpp:461
      pragma Import (CPP, showHSIHistogram, "_ZN15Processing_Wrap16showHSIHistogramEPi");

      function compareHSVHistograms
        (this : access Processing_Wrap;
         src1 : int;
         src2 : int;
         compareMethod : int) return double;  -- visionBindings.cpp:490
      pragma Import (CPP, compareHSVHistograms, "_ZN15Processing_Wrap20compareHSVHistogramsEiii");

      procedure approxPolyDP
        (this : access Processing_Wrap;
         epsilon : double;
         closed : Extensions.bool);  -- visionBindings.cpp:340
      pragma Import (CPP, approxPolyDP, "_ZN15Processing_Wrap12approxPolyDPEdb");

      procedure splitChannels (this : access Processing_Wrap; src : int);  -- visionBindings.cpp:395
      pragma Import (CPP, splitChannels, "_ZN15Processing_Wrap13splitChannelsEi");

      procedure showBlueChannel (this : access Processing_Wrap);  -- visionBindings.cpp:523
      pragma Import (CPP, showBlueChannel, "_ZN15Processing_Wrap15showBlueChannelEv");

      procedure showGreenChannel (this : access Processing_Wrap);  -- visionBindings.cpp:531
      pragma Import (CPP, showGreenChannel, "_ZN15Processing_Wrap16showGreenChannelEv");

      procedure thresh
        (this : access Processing_Wrap;
         src : int;
         dst : int;
         blueLow : int;
         blueUp : int;
         greenLow : int;
         greenUp : int;
         redLow : int;
         redUp : int);  -- visionBindings.cpp:559
      pragma Import (CPP, thresh, "_ZN15Processing_Wrap6threshEiiiiiiii");

      procedure showRedChannel (this : access Processing_Wrap);  -- visionBindings.cpp:539
      pragma Import (CPP, showRedChannel, "_ZN15Processing_Wrap14showRedChannelEv");

      procedure LabelPoints (this : access Processing_Wrap; src : int);  -- visionBindings.cpp:244
      pragma Import (CPP, LabelPoints, "_ZN15Processing_Wrap11LabelPointsEi");

      procedure gaussianBlur
        (this : access Processing_Wrap;
         src : int;
         dest : int;
         kersize : int;
         sigmaX : double;
         sigmaY : double);  -- visionBindings.cpp:657
      pragma Import (CPP, gaussianBlur, "_ZN15Processing_Wrap12gaussianBlurEiiidd");

      procedure objectTracking (this : access Processing_Wrap; src : int);  -- visionBindings.cpp:597
      pragma Import (CPP, objectTracking, "_ZN15Processing_Wrap14objectTrackingEi");

      procedure roi
        (this : access Processing_Wrap;
         src : int;
         dst : int);  -- visionBindings.cpp:668
      pragma Import (CPP, roi, "_ZN15Processing_Wrap3roiEii");

      procedure goodFeatures (this : access Processing_Wrap; src : int);  -- visionBindings.cpp:547
      pragma Import (CPP, goodFeatures, "_ZN15Processing_Wrap12goodFeaturesEi");

      procedure fusion
        (this : access Processing_Wrap;
         src : int;
         dst : int);  -- visionBindings.cpp:784
      pragma Import (CPP, fusion, "_ZN15Processing_Wrap6fusionEii");

      function estimateVelocity (this : access Processing_Wrap) return float;  -- visionBindings.cpp:696
      pragma Import (CPP, estimateVelocity, "_ZN15Processing_Wrap16estimateVelocityEv");

      procedure GaussianBlurSharpener
        (this : access Processing_Wrap;
         src : int;
         destination : int;
         accuracy : int);  -- visionBindings.cpp:681
      pragma Import (CPP, GaussianBlurSharpener, "_ZN15Processing_Wrap21GaussianBlurSharpenerEiii");

      procedure estPosition (this : access Processing_Wrap);  -- visionBindings.cpp:747
      pragma Import (CPP, estPosition, "_ZN15Processing_Wrap11estPositionEv");

      procedure invertImage
        (this : access Processing_Wrap;
         src : int;
         dst : int);  -- visionBindings.cpp:808
      pragma Import (CPP, invertImage, "_ZN15Processing_Wrap11invertImageEii");

      function matchImage (this : access Processing_Wrap; src : int) return int;  -- visionBindings.cpp:818
      pragma Import (CPP, matchImage, "_ZN15Processing_Wrap10matchImageEi");

      procedure cloneImage
        (this : access Processing_Wrap;
         src : int;
         dst : int);  -- visionBindings.cpp:965
      pragma Import (CPP, cloneImage, "_ZN15Processing_Wrap10cloneImageEii");

      procedure enhanceColors
        (this : access Processing_Wrap;
         src : int;
         dest : int;
         channel : int;
         level : double);  -- visionBindings.cpp:942
      pragma Import (CPP, enhanceColors, "_ZN15Processing_Wrap13enhanceColorsEiiid");

      procedure fillInPoly (this : access Processing_Wrap);  -- visionBindings.cpp:901
      pragma Import (CPP, fillInPoly, "_ZN15Processing_Wrap10fillInPolyEv");

      procedure classifyMatch (this : access Processing_Wrap; bestTemplateMatch : int);  -- visionBindings.cpp:875
      pragma Import (CPP, classifyMatch, "_ZN15Processing_Wrap13classifyMatchEi");

      function New_Processing_Wrap return Processing_Wrap;  -- visionBindings.cpp:972
      pragma CPP_Constructor (New_Processing_Wrap, "_ZN15Processing_WrapC1Ev");


   end;
   use Class_Processing_Wrap;
   package Class_Preprocessing_Wrap is
      type Preprocessing_Wrap is tagged limited record
         null;
      end record;
      pragma Import (CPP, Preprocessing_Wrap);

      procedure VideoCaptureOpen (this : access Preprocessing_Wrap);  -- visionBindings.cpp:984
      pragma Import (CPP, VideoCaptureOpen, "_ZN18Preprocessing_Wrap16VideoCaptureOpenEv");

      procedure namedWindow
        (this : access Preprocessing_Wrap;
         name : Interfaces.C.Strings.chars_ptr;
         num : int);  -- visionBindings.cpp:989
      pragma Import (CPP, namedWindow, "_ZN18Preprocessing_Wrap11namedWindowEPci");

      procedure nextFrame (this : access Preprocessing_Wrap; dst : int);  -- visionBindings.cpp:994
      pragma Import (CPP, nextFrame, "_ZN18Preprocessing_Wrap9nextFrameEi");

      procedure contrast
        (this : access Preprocessing_Wrap;
         src : int;
         dst : int;
         gain : int;
         bias : int);  -- visionBindings.cpp:999
      pragma Import (CPP, contrast, "_ZN18Preprocessing_Wrap8contrastEiiii");

      procedure quaterNionSwitchingFilter
        (this : access Preprocessing_Wrap;
         src : int;
         dst : int;
         QNSFThresh : double);  -- visionBindings.cpp:1010
      pragma Import (CPP, quaterNionSwitchingFilter, "_ZN18Preprocessing_Wrap25quaterNionSwitchingFilterEiid");

      function New_Preprocessing_Wrap return Preprocessing_Wrap;  -- visionBindings.cpp:1140
      pragma CPP_Constructor (New_Preprocessing_Wrap, "_ZN18Preprocessing_WrapC1Ev");


   end;
   use Class_Preprocessing_Wrap;
end visionBindings_hpp;
