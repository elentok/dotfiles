load 'scripts/cphotos'

require 'fileutils'

describe '#analyze' do
  before :each do
    FileUtils.rm_rf '/tmp/photos-target'
    FileUtils.mkdir_p '/tmp/photos-target/2016/02-01'
    FileUtils.mkdir_p '/tmp/photos-target/2016/01-05 description'
    FileUtils.mkdir_p '/tmp/photos-target/2016/01-06_10 multi day trip'
    FileUtils.mkdir_p '/tmp/photos-target/2016/03-30_04-12 multi day trip'

    FileUtils.cp 'test/fixtures/photos-source/P1020307.JPG',
      '/tmp/photos-target/2016/02-01/0102-p1020307-blabla.jpg'

    FileUtils.cp 'test/fixtures/exif.jpg',
      '/tmp/photos-target/2016/02-01/0202-p1020308-fz1000.jpg'

    IO.write '/tmp/photos-target/copy.log',
      ">> 2016-10-05 0102-p1020310"
  end

  after :each do
    FileUtils.rm_rf '/tmp/photos-target'
  end

  it 'analyzes' do
    result = analyze('test/fixtures/photos-source', '/tmp/photos-target')

    expect(result.added.length).to eq 4

    expect(result.added[0].target).to eq \
      '/tmp/photos-target/2016/02-10/1020-p1020304-fz1000.jpg'

    expect(result.added[1].target).to eq \
      '/tmp/photos-target/2016/01-05 description/0102-p1020305-fz1000.jpg'

    expect(result.added[2].target).to eq \
      '/tmp/photos-target/2016/01-06_10 multi day trip/day02/0102-p1020306-fz1000.jpg'

    expect(result.added[3].target).to eq \
      '/tmp/photos-target/2016/03-30_04-12 multi day trip/day04/0102-p1020309-fz1000.jpg'

    expect(result.deleted.length).to eq 1

    expect(result.deleted[0].target).to eq \
      '/tmp/photos-target/2016/10-05/0102-p1020310-fz1000.jpg'
  end
end
