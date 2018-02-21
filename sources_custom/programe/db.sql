#
#    Program E
#    Copyright 2002, Paul Rydell
#	
#    This file is part of Program E.
#	
#    Program E is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    Program E is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Program E; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#


#
# Table structure for table `bot`
#

CREATE TABLE bot (
  id int(11) NOT NULL auto_increment,
  bot tinyint(4) NOT NULL default '0',
  name varchar(255) NOT NULL default '',
  value text NOT NULL,
  PRIMARY KEY  (id),
  KEY botname (bot,name)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `bots`
#

CREATE TABLE bots (
  id tinyint(3) unsigned NOT NULL auto_increment,
  botname varchar(255) NOT NULL default '',
  PRIMARY KEY  (botname),
  KEY id (id)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `conversationlog`
#

CREATE TABLE conversationlog (
  bot tinyint(3) unsigned NOT NULL default '0',
  id int(11) NOT NULL auto_increment,
  input text,
  response text,
  uid varchar(255) default NULL,
  enteredtime timestamp(14) NOT NULL,
  PRIMARY KEY  (id),
  KEY botid (bot)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `dstore`
#

CREATE TABLE dstore (
  uid varchar(255) default NULL,
  name text,
  value text,
  enteredtime timestamp(14) NOT NULL,
  id int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id),
  KEY nameidx (name(40))
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `gmcache`
#

CREATE TABLE gmcache (
  id int(11) NOT NULL auto_increment,
  bot tinyint(3) unsigned NOT NULL default '0',
  template int(11) NOT NULL default '0',
  inputstarvals text,
  thatstarvals text,
  topicstarvals text,
  patternmatched text,
  inputmatched text,
  combined text NOT NULL,
  PRIMARY KEY  (id),
  KEY combined (bot,combined(255))
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `gossip`
#

CREATE TABLE gossip (
  bot tinyint(3) unsigned NOT NULL default '0',
  gossip text,
  id int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id),
  KEY botidx (bot)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `patterns`
#

CREATE TABLE patterns (
  bot tinyint(3) unsigned NOT NULL default '0',
  id int(11) NOT NULL auto_increment,
  word varchar(255) default NULL,
  ordera tinyint(4) NOT NULL default '0',
  parent int(11) NOT NULL default '0',
  isend tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY wordparent (parent,word),
  KEY botid (bot)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `templates`
#

CREATE TABLE templates (
  bot tinyint(3) unsigned NOT NULL default '0',
  id int(11) NOT NULL default '0',
  template text NOT NULL,
  pattern varchar(255) default NULL,
  that varchar(255) default NULL,
  topic varchar(255) default NULL,
  PRIMARY KEY  (id),
  KEY bot (id)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `thatindex`
#

CREATE TABLE thatindex (
  uid varchar(255) default NULL,
  enteredtime timestamp(14) NOT NULL,
  id int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) TYPE=MyISAM;
# --------------------------------------------------------

#
# Table structure for table `thatstack`
#

CREATE TABLE thatstack (
  thatid int(11) NOT NULL default '0',
  id int(11) NOT NULL auto_increment,
  value varchar(255) default NULL,
  enteredtime timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;
