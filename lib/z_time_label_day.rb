# -*- coding: utf-8 -*-
# 
class ZTimeLabelDay < ZTimeLabel

  def self.get_timeblocks(id, t1, t2, inc)
    (super).each do |b|
      b.title = b.starttime.strftime "%a, %b %e"
      b.css_classes = 'ZTimeHeaderDayRow '
    end
  end


  def self.end_for_start( t )
    (t.end_of_day + 1).beginning_of_day  # 0.00001 or whatever
  end

  # t is a TimeWithZone or similar
  def self.floor(t)
    t.beginning_of_day
  end

end

