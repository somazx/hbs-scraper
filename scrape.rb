class Scrape
  attr_accessor :timberMark, :fromDate, :toDate

  def initialize(*args)
    @timberMark, @fromDate, @toDate = *args
  end

  def document
    body = Net::HTTP.get(URI.parse(url))
    document = Oga.parse_html(body)
  end

  def url
    "https://a100.gov.bc.ca/pub/hbs/opq/IssuedDocSearch.do"\
    "?criteria.timberMark=#{timberMark}"\
    "&criteria.radScaleType=WSI"\
    "&chcScaleDateFromDate=#{fromDate}"\
    "&chcScaleDateToDate=#{toDate}"
  end

  def headers
    document.css('.recordsetheader-center').collect { |header| header.text.strip }
  end

  def values
    document.css('table table:nth-child(4) tr')[1..-1].collect do |tr|
      values = tr.css('td')[0..1].collect(&:text).collect(&:strip)
      values.push *tr.css('td')[2..-1].collect(&:text).collect(&:strip)
    end
  end

  def data
    { headers: headers, invoices: values }
  end

  def to_json
    JSON.generate(data)
  end
end
