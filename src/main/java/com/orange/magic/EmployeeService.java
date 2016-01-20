package com.orange.magic;

import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.orange.magic.domain.Village;
import com.orange.magic.mapper.VillageMapper;

@Service
@Path("/employ")
public class EmployeeService {
	
	@Autowired
	private VillageMapper villageMapper;
    
	@GET
	@Path("/{id}")
	@Produces("application/json")
	public Response getEmp(@PathParam("id") String id) {
		Village village = new Village();
		village.setVid(1);
		village.setVillageName("xx");
		village.setDistrict("yy");
		villageMapper.insertVillage(village);
		Map<String, String> map = new HashMap<String, String>();
		map.put("Id", id);
		map.put("Name", "Arvind Rai");
		map.put("Location", "Varanasi");
		return Response.ok(map).build();
	}
}
