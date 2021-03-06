load 'scripts/cphotos'

require 'fileutils'

describe '#analyze' do
  before :each do
    FileUtils.rm_rf '/tmp/photos-target'
    FileUtils.mkdir_p '/tmp/photos-target/2016/02-01'
    FileUtils.mkdir_p '/tmp/photos-target/2016/01-05 description'
    FileUtils.mkdir_p '/tmp/photos-target/2016/01-06_10 multi day trip'
    FileUtils.mkdir_p '/tmp/photos-target/2016/03-30_04-12 multi day trip'
    FileUtils.mkdir_p '/tmp/photos-target/2016/05-06 desc/subdir'

    FileUtils.cp 'test/fixtures/photos-source/P1020307.JPG',
                 '/tmp/photos-target/2016/02-01/20160201-0102-p1020307-blabla.jpg'

    FileUtils.cp 'test/fixtures/photos-source/P1020311.JPG',
                 '/tmp/photos-target/2016/05-06 desc/subdir/' \
                 '20160506-1020-p1020311-blabla.jpg'

    FileUtils.cp 'test/fixtures/exif.jpg',
                 '/tmp/photos-target/2016/02-01/20160201-0202-p1020308-fz1000.jpg'

    IO.write '/tmp/photos-target/copy.log', '>> 20161005-0102-p1020310'
  end

  after :each do
    FileUtils.rm_rf '/tmp/photos-target'
  end

  it 'analyzes' do
    a = Analysis.new('test/fixtures/photos-source', '/tmp/photos-target')
    a.analyze

    expect(a.added.length).to eq 4

    expect(a.added[0].target).to eq \
      '/tmp/photos-target/2016/02-10/20160210-1020-p1020304-fz1000.jpg'

    expect(a.added[1].target).to eq \
      '/tmp/photos-target/2016/01-05 description/20160105-0102-p1020305-fz1000.jpg'

    expect(a.added[2].target).to eq \
      '/tmp/photos-target/2016/01-06_10 multi day trip/day02/' \
      '20160107-0102-p1020306-fz1000.jpg'

    expect(a.added[3].target).to eq \
      '/tmp/photos-target/2016/03-30_04-12 multi day trip/day04/' \
      '20160402-0102-p1020309-fz1000.jpg'

    expect(a.deleted.length).to eq 1

    expect(a.deleted[0].target).to eq \
      '/tmp/photos-target/2016/10-05/20161005-0102-p1020310-fz1000.jpg'
  end
end
