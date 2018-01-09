/**
 * Copyright 山东众阳软件有限公司 All rights reserved.
 */
package com.basic.model;

import java.io.Serializable;

/**
 * @author cyj
 *
 */

public class OrganizationHospital implements Serializable {

	private Long id;

	private Long organizationId;

	private Long hospitalId;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(Long organizationId) {
		this.organizationId = organizationId;
	}

	public Long getHospitalId() {
		return hospitalId;
	}

	public void setHospitalId(Long hospitalId) {
		this.hospitalId = hospitalId;
	}

	@Override
	public String toString() {
		return "OrganizationHospital{" + "id=" + id + ", organizationId=" + organizationId + ", hospitalId="
				+ hospitalId + '}';
	}

}
