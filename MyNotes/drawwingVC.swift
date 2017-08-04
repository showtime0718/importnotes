//
//  drawwingVC.swift
//  Mynote
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 swift006. All rights reserved.
//

import UIKit

class drawwingVC: UIView {
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    
    private var viewW:CGFloat = 0
    private var viewH:CGFloat = 0
    private var lines:Array<Array<(CGFloat,CGFloat)>> = [[]]
    private var recycle:Array<Array<(CGFloat,CGFloat)>> = [[]]
    private var colors :Array<Array<UIColor>> = [[]]
    private var uncolors :Array<Array<UIColor>> = [[]]
    private var isInit = false
    private var context:CGContext?
    let app = UIApplication.shared.delegate as! AppDelegate

    
    
    
    private func initState(_ rect:CGRect){
        isInit = true
        
        viewW = rect.size.width
        viewH = rect.size.height
        context = UIGraphicsGetCurrentContext()
        
        
    }
    func takeSnapshotOfView(view:UIView) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: view.frame.size.width, height: view.frame.size.height))
        view.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    override func draw(_ rect:CGRect){
        if !isInit{initState(rect)}
        context?.setLineWidth(10)
        context?.setStrokeColor(red: 0, green: 1, blue: 1, alpha: 1)
        for j in 0..<lines.count{
            if lines[j].count<=1 {continue}
            for i in 1..<lines[j].count {
                let (p0x, p0y) = lines[j][i-1]
                let (p1x, p1y) = lines[j][i]
                let color = colors[j][i].cgColor
                context?.setStrokeColor(color)
                context?.move(to: CGPoint(x: p0x, y: p0y))
                context?.addLine(to: CGPoint(x: p1x, y: p1y))
                context?.drawPath(using: CGPathDrawingMode.stroke)
               
                
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let point:CGPoint = touch.location(in: self)
        
        recycle = [[]]
        lines += [[]]
        colors += [[]]
        //放入color值
        let color = app.color
        colors[colors.count - 1] += [color]
        lines[lines.count - 1] += [(point.x , point.y)]
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let point:CGPoint = touch.location(in: self)

        let color = app.color

        colors[colors.count - 1] += [color]
        lines[lines.count-1] += [(point.x , point.y)]
        setNeedsDisplay()
    }
    func clear(){
        lines = [[]]
        recycle = [[]]
        colors = [[]]
        setNeedsDisplay()
        
    }
    func undo(){
        if lines.count > 0 {
            recycle += [lines.remove(at: lines.count - 1)]
            uncolors += [colors.remove(at: colors.count - 1)]
            setNeedsDisplay()
        }
    }
    func redo(){
        if recycle.count > 0 {
            lines += [recycle.remove(at: recycle.count - 1)]
            setNeedsDisplay()
            
        }
            }
    
    

}
