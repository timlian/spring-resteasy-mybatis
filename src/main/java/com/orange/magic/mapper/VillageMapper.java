package com.orange.magic.mapper;

import org.apache.ibatis.annotations.Insert;

import com.orange.magic.domain.Village;

public interface VillageMapper {
	@Insert("INSERT into village(id,name,district) VALUES(#{vid}, #{villageName}, #{district})")
	void insertVillage(Village village);
}