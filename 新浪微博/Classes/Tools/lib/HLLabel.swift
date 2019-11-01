//
//  HLLabel.swift
//  HLLabel
//
//  Created by 梁华建 on 2019/9/24.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
protocol HLLabelDelegate : NSObjectProtocol {
    func didSelectHighLightedText(label : HLLabel , string : String)
}
class HLLabel: UILabel {
    //MARK: - Life cycle
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        ///Prepare the textkit drawing system
        textStorage.addLayoutManager(layoutManager)
        
        layoutManager.addTextContainer(textContainer)
        
        isUserInteractionEnabled = true
        
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        textContainer.size = bounds.size
        
    }
    //MARK: - Variables didSet
    public override var text: String?{
        didSet{
            updateTextStorage()
        }
    }
    
    public override var attributedText: NSAttributedString?{
        didSet{
            updateTextStorage()
        }
    }
    
    public override var font: UIFont!{
        didSet{
            updateTextStorage()
        }
    }
    
    public override var textColor: UIColor!{
        didSet{
            updateTextStorage()
        }
    }
    //MARK: - Draw text
    public override func drawText(in rect: CGRect) {
        
        //Do not call super here, we have to complete the rendering ourselves, otherwise there will be two layers of text.
        // Get the length of the text to be highlighted
        let range = glyphsRange()
        ///The offset prevent the text from getting covered
        //let offset = glyphsOffset(range: range)
        //Draw background
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint.zero)
        //Draw text
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
        
    }
    
    private func glyphsRange() -> NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }
    
    private func glyphsOffset(range: NSRange) -> CGPoint {
        
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        
        let height = (bounds.height - rect.height) * 0.5
        
        return CGPoint(x: 0, y: height)
    }
    
    ///This method is called to re-render when the color, size or content of the text changes.
    public func updateTextStorage()
    {
        if attributedText == nil
        {
            return
        }
        
        let attrStringM = addLineBreak(attrString : attributedText!)
        
        regexHighlightRanges(attrString : attrStringM)
        
        highLightAttribute(attrStringM : attrStringM)
        
        textStorage.setAttributedString(attrStringM)
        
        //下一次drawingCycle渲染
        setNeedsDisplay()
    }
    
    ///Add lineBreakMode and return a mutableAttributedString
    public func addLineBreak(attrString : NSAttributedString) -> NSMutableAttributedString {
        
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        if attrString.length == 0
        {
            return attrStringM
        }
        
        var range = NSRange(location: 0, length: 0)
        
        //Get the attribute of the attributedString text, note that the range passed in here is a pointer, the length of the range is the length of the string after the method ends.
        var attributes = attrString.attributes(at: 0, effectiveRange: &range)
        
        var paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            
            paragraphStyle!.lineBreakMode = .byWordWrapping
            
        }else
        {
            paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle?.lineBreakMode = .byWordWrapping
            
            attributes[.paragraphStyle] = paragraphStyle
            
            attrStringM.setAttributes(attributes, range: range)
        }
        
        return attrStringM
    }
    
    ///Get the ranges you want to highlight by regular matching
    public func regexHighlightRanges(attrString : NSAttributedString)
    {
        highLightedRanges.removeAll()
        
        let regexRange = NSRange(location: 0, length: attrString.string.count)
        
        for pattern in patterns {
            
            let regex = try! NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            
            //获取正则匹配到的需要高亮的range
            let results = regex.matches(in: attrString.string, options: NSRegularExpression.MatchingOptions.reportProgress, range: regexRange)
            
            for r in results
            {
                highLightedRanges.append(r.range(at:0))
            }
            
        }
        
    }
    
    ///Highlighted the strings in highLighted ranges
    private func highLightAttribute(attrStringM : NSMutableAttributedString) {
        
        if attrStringM.length == 0 {
            return
        }
        
        var range = NSRange(location: 0, length: 0)
        
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        //Maybe the font or textColor has changed, we have to recopy it, otherwise it may cause the font to be changed.
        attributes[.font] = font
        
        attributes[.foregroundColor] = textColor
        
        attrStringM.addAttributes(attributes, range: range)
        
        attributes[.foregroundColor] = UIColor.blue
        
        for r in highLightedRanges {
            
            attrStringM.setAttributes(attributes, range: r)
            
        }
    }
    //MAKR: - Touch's event
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let range = clickHighlightedString(location: touches.first!.location(in: self)) else
        {
            
            return
        }
        
        selectedRange = range
        
        highlightSelectedRange(isSet: true)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           if selectedRange == nil
           {
               return
           }
           delegate?.didSelectHighLightedText(label: self, string: attributedText!.attributedSubstring(from: selectedRange!).string)
           
           highlightSelectedRange(isSet: false)
       }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let range = clickHighlightedString(location: touches.first!.location(in: self))
        {
            if range != selectedRange
            {   //Update selected range
                highlightSelectedRange(isSet: false)
                selectedRange = range
                highlightSelectedRange(isSet: true)
            }
            
        }else
        {
            highlightSelectedRange(isSet: false)
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if selectedRange == nil
        {
            return
        }
        
        delegate?.didSelectHighLightedText(label: self, string: attributedText!.attributedSubstring(from: selectedRange!).string)
        
        highlightSelectedRange(isSet: false)
    }
    
    private func highlightSelectedRange(isSet : Bool) {
        
        guard let range = selectedRange else {
            return
        }
        
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        
        attributes[.foregroundColor] = highlightedTextColor
        if isSet
        {
            attributes[.backgroundColor] = selectedBackgroundColor
        }
        else
        {
            attributes[.backgroundColor] = UIColor.clear
            
            selectedRange = nil
        }
        self.textStorage.addAttributes(attributes, range: range)
        
        setNeedsDisplay()
    }
    
    ///Return the highLighted text if it's clicked
    private func clickHighlightedString(location:CGPoint) -> NSRange?
    {
        if textStorage.length == 0
        {
            return nil
        }
        //We set the offset as we drawing the text
        let offset = glyphsOffset(range: glyphsRange())
        
        let point = CGPoint.init(x: offset.x + location.x, y: offset.y + location.y)
        
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        //Why we need to second check the location of index , cause the glyphIndex(for: point, in: textContainer) will return the last index if we click the outside of the text , it will high light the range and we need to avoid this situation.
        
        let locationInIndex = layoutManager.location(forGlyphAt: index)
        
        for r in highLightedRanges
        {
            if index >= r.location && index <= r.location + r.length && location.x >= locationInIndex.x
            {
                return r
            }
        }
        
        return nil
    }
    //MARK: - Member variables
    //Patterns for regular expression
    private var patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*","全文"]
    
    ///Record which ranges need to be highlighted
    private var highLightedRanges = [NSRange]()
    
    private lazy var textStorage = NSTextStorage()
    
    private lazy var layoutManager = NSLayoutManager()
    
    private lazy var textContainer = NSTextContainer()
    
    public var selectedRange : NSRange?
    
    public var selectedBackgroundColor = UIColor.lightGray
    
    public var delegate : HLLabelDelegate?
}
