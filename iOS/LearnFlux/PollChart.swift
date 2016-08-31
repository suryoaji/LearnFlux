//
//  PollChart.swift
//  LearnFlux
//
//  Created by ISA on 8/26/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit
import Charts

class PollChart: UIViewController, ChartViewDelegate {

    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var chartView: PieChartView!
    var parties : Array<String> = []
    var value : Array<Double> = []
    
    func initPollChart(answers: Array<String>, answerers: Dictionary<String, Int>, participant: Array<Participant>){
        var tmpParties = answers
        tmpParties.append("Not Answered")
        var tmpValue = Array(count: tmpParties.count, repeatedValue: 0.0)
        for each in answerers{
            tmpValue[each.1] += 1
        }
        tmpValue[tmpParties.count-1] = Double(participant.count - answerers.count)
        for i in 0..<tmpValue.count{
            if tmpValue[i] > 0{
                parties.append(tmpParties[i])
                value.append(tmpValue[i])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "Pie Bar Chart"
        self.setupPieChartView(chartView)
        self.chartView.delegate = self
        
        self.setDataCount(parties.count, range: 100)
        chartView.animate(xAxisDuration: 1.4, easingOption: .EaseOutBack)
    }
    
//    func updateChartData() {
//        self.setDataCount(Int(sliderX.value), range: Double(sliderY.value))
//    }
    
    func setupPieChartView(chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.descriptionText = ""
        chartView.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        chartView.drawCenterTextEnabled = true
        let paragraphStyle : NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        paragraphStyle.alignment = .Center
        let centerText = NSMutableAttributedString(string: String("Charts\nby Daniel Cohen Gindi"), attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 13.0)!, NSParagraphStyleAttributeName: paragraphStyle])
        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 11.0)!, NSForegroundColorAttributeName: UIColor.grayColor()], range: NSMakeRange(10, centerText.length - 10))
        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-LightItalic", size: 11.0)!, NSForegroundColorAttributeName: UIColor(red: 51 / 255.0, green: 181 / 255.0, blue: 229 / 255.0, alpha: 1.0)], range: NSMakeRange(centerText.length - 19, 19))
        chartView.centerAttributedText = centerText
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0.0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        let l = chartView.legend
        l.position = .AboveChartLeft
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
        l.textColor = UIColor.whiteColor()
    }
    
    func setDataCount(count: Int, range: Double) {
        let mult: Double = range
        var values = [ChartDataEntry]()
        // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
        for i in 0..<count {
            values.append(ChartDataEntry(value: value[i] / value.reduce(0, combine: { $0 + $1 }) * mult, xIndex: i % parties.count))
        }
        let dataSet = PieChartDataSet(yVals: values, label: "Election Results")
        dataSet.sliceSpace = 2.0
        // add a lot of colors
        var colors = [NSUIColor]()
        colors += ChartColorTemplates.vordiplom()
        colors += ChartColorTemplates.joyful()
        colors += ChartColorTemplates.colorful()
        colors += ChartColorTemplates.liberty()
        colors += ChartColorTemplates.pastel()
        colors.append(UIColor(red: 51 / 255.0, green: 181 / 255.0, blue: 229 / 255.0, alpha: 1.0))
        dataSet.colors = colors
        dataSet.yValuePosition = .InsideSlice
        let data = PieChartData(xVals: parties, dataSets: [dataSet])
        let pFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .PercentStyle
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(pFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.whiteColor())
        self.chartView.data = data
        chartView.highlightValues(nil)
        chartView.data?.setValueTextColor(UIColor.blackColor())
        chartView.data?.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 17.0))
    }
    
    // MARK: - ChartViewDelegate
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight){
//        print(entry)
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
//        print("chartValueNothingSelected")
        self.performSegueWithIdentifier("unwindSegue", sender: nil)
    }

}
