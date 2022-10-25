//
//  ViewController.swift
//  MAwalkHolic
//
//  Created by yangjs on 2022/10/06.
//

import UIKit
import Charts
import HealthKit
import RxCocoa
import RxSwift


class MainController: UIViewController {
    let bag = DisposeBag()
    private var observer: NSObjectProtocol?
    let vm = MainViewModel()
    
    
    
    let axisValues = ["D-6","D-5","D-4","D-3","D-2","D-1","오늘"]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: BarChartView!
    let typeToShare = HKQuantityType.quantityType(forIdentifier: .stepCount)
    let typeToRead = HKQuantityType.quantityType(forIdentifier: .stepCount)
    
    var stepDataList : [String] = []
    var stepList : [StepModel] = [StepModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
        
        //tableView.dataSource = self
        self.title = "워커홀릭"
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] noti in
            self.vm.didEnterForeground.onNext(())
        }
        bind()
        
    }
    
    func bind(){
        //테이블뷰
        vm.stepListLoaded.bind(to: tableView.rx.items){(tableView, row, stepinfo) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: row, section: 0))
            cell.textLabel?.text = stepinfo.date.toString()
            cell.detailTextLabel?.text = "\(Int(stepinfo.step)) 보"
            return cell
        }.disposed(by: bag)
        
        //차트그리기
        vm.stepListLoaded.asDriver(onErrorJustReturn: []).drive( onNext: {[weak self] stepList in
            guard let self = self else {return }
            self.drawChart(stepList: stepList)
        }).disposed(by: bag)
        
        //테이브뷰 최상단
        vm.stepListLoaded
            .map{_ in return true}
            .asDriver(onErrorJustReturn: true)
            .drive(onNext:{ _ in
                let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            })
            .disposed(by: bag)
    }
    override func viewDidDisappear(_ animated: Bool) {
        observer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("printViewwillAeppear")
    }
    
    func configure(){
        print("configure")
        if HKHealthStore.isHealthDataAvailable(){
            requestAuthorization()
            
        }
        //setHealthData()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        vm.didEnterForeground.onNext(())
    }
    
    func requestAuthorization(){
        vm.healthStore.requestAuthorization(toShare: Set([typeToShare!]), read: Set([typeToRead!])) { [weak self] success, error in
            if success{
                self?.vm.authorizeSuccess.onNext(true)
                
            }else{
                self?.vm.authorizeSuccess.onNext(false)
                print(error?.localizedDescription ?? "권산 승인 실패")
            }
            
        }
    }
    
    
    // NOT USE
//    func saveStepCount(stepValue: Int, date: Date, completion: @escaping (Error?) -> Void) {
//        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
//        let stepCountUnit: HKUnit = HKUnit.count()
//        let stepCountQuantity = HKQuantity(unit: stepCountUnit, doubleValue: Double(stepValue))
//
//        let stepCountSample = HKQuantitySample(type: stepCountType, quantity: stepCountQuantity, start: date, end: date)
//
//        self.healthStore.save(stepCountSample) { (success, error) in
//            if let error = error {
//                completion(error)
//                print("Error Saving Steps count Sample: \(error.localizedDescription)")
//            } else {
//                completion(nil)
//                print("Successfully saves step count sample")
//            }
//        }
//    }
    
    
    func drawChart(stepList:[StepModel]){
        var tmp  = [BarChartDataEntry]()
        if stepList.count < 7{
            return
        }
        var cnt = 0
        for i in (0...6).reversed(){
            tmp.append(BarChartDataEntry(x: Double(cnt), y: stepList[i].step))
            cnt+=1
        }
        print(tmp)
        let chartDataSet = BarChartDataSet(entries: tmp, label: "걷기")
        chartDataSet.colors = [.systemPink]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        self.chartView.data = chartData
        // 선택 안되게
        chartDataSet.highlightEnabled = false
        // 줌 안되게
        self.chartView.doubleTapToZoomEnabled = false
        
        print(self.chartView.xAxis.labelCount)
        self.chartView.xAxis.labelPosition = .bottom
        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.axisValues)
        
        let minimumRecord = ChartLimitLine(limit: 7000.0, label: "7000보")
        
        
        self.chartView.leftAxis.addLimitLine(minimumRecord)
        self.chartView.leftAxis.axisMinimum = 0
    }
}

