require 'pdf-reader'

NON_DATA_STRINGS = [
  'Updated March 18 , 2020',
  'COVID-19 RESOURCES FOR FRANKLIN',
  'COUNTY RESIDENTS',
  'Compiled by Columbus Public Health',
  '240 Parsons Ave',
  '(614) 645-6807 or 645-3111',
  'www.publichealth.columbus.gov',
  'Page',
  'COLUMBUS AREA FOOD PANTRIES & SOUP KITCHENS',
  'Disclaimer',
  'represent all the Pantries and Meals',
  'information understood to'
].freeze

def main
  reader = PDF::Reader.new('COVID-19 RESOURCES.pdf')
  text = reader.pages.map do |page|
    page.text.split(/\n+/)
      .reject { |t| t.strip.empty? }
      .reject { |t| NON_DATA_STRINGS.any? { |s| t[s] } }
  end

  text = text.map do |page|
    reduce_page_to_single_column(page)
  end

  File.open('parsed_pdf.txt', 'w') do |f|
    text.map.map { |t| f.puts t }
  end
end

def reduce_page_to_single_column(page)
  first_column = []
  second_column = []
  page.each do |line|
    cols = line.split(/    \s+/)
    next if cols.size > 2
    first_column << cols[0].strip unless cols[0].strip.empty?
    second_column << cols[1].strip unless !cols[1] || cols[1].strip.empty?
  end
  first_column + second_column
end

main
